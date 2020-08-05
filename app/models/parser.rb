# frozen_string_literal: true

class Parser
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Attributes::Dynamic

  include TemplateHelpers

  include Versioned

  field :strategy,  type: String
  field :content,   type: String
  field :data_type, type: String, default: 'record'
  field :allow_full_and_flush, type: Boolean, default: true

  # Used for the /parsers page which includes these 3 fields
  # As MongoDB doesn't allow to sort and search accross collections
  field :last_editor,  type: String
  field :partner_name, type: String
  field :source_name,  type: String

  # Adding indexes across all fields so we can sort them in the datatable.
  index(name: 1)
  index(strategy: 1)
  index(source: 1)
  index(data_type: 1)
  index(updated_at: 1)
  index(last_editor: 1)
  index(source_name: 1)
  index(partner_name: 1)

  attr_accessor :parser_template_name, :error

  belongs_to :source
  accepts_nested_attributes_for :source
  validates :source, presence: true, associated: true

  VALID_STRATEGIES = ['json', 'oai', 'rss', 'xml']

  VALID_DATA_TYPE = ['record', 'concept']

  # ENVIRONMENTS = [:staging, :production]
  validates_presence_of   :name, :strategy, :data_type
  validates_uniqueness_of :name
  validates_inclusion_of  :strategy, in: VALID_STRATEGIES
  validates_inclusion_of  :data_type, in: VALID_DATA_TYPE

  validate :parser_name_is_a_valid_class_name

  before_create :apply_parser_template!

  before_destroy { |parser| HarvestSchedule.destroy_all_for_parser(parser.id) }

  before_save :update_last_editor
  before_save :update_partner_name
  before_save :update_source_name

  def parser_name_is_a_valid_class_name
    errors.add(:name, 'Your Parser Name includes invalid characters. Please remove the /.') if name.include? '/'
    class_name.constantize
  rescue NameError => e
    if e.message.include? 'wrong constant name'
      errors.add(:name, 'Parser name includes invalid characters. The name can only contain Alphabetical or Numeric characters, and can not start with a number.')
    end
  end

  def self.datatable_query(params)
    Parser
      .offset(params[:start])
      .limit(params[:per_page])
      .order_by(params[:order_by] => params[:direction])
      .includes(:source)
      .only(
        :name,
        :strategy,
        :source,
        :data_type,
        :updated_at,
        :last_editor,
        :source_name,
        :partner_name
      ).where(
        '$or' => [
          { name:         /#{params[:search]}/i },
          { strategy:     /#{params[:search]}/i },
          { data_type:    /#{params[:search]}/i },
          { last_editor:  /#{params[:search]}/i },
          { partner_name: /#{params[:search]}/i },
          { source_name:  /#{params[:search]}/i },
        ]
      )
  end

  def self.find_by_partners(partner_ids = [])
    sources = Source.where(:partner.in => partner_ids).pluck(:id)
    @parsers = Parser.where(:source.in => sources)
  end

  def class_name
    name.gsub(/\s/, '').camelize
  end

  def file_name
    @file_name ||= name.downcase.gsub(/\s/, '_') + '.rb'
  end

  def path
    "#{strategy}/#{file_name}"
  end

  def running_jobs?
    active_jobs = []
    APPLICATION_ENVS.each do |environment|
      active_jobs << AbstractJob.search({ parser_id: self.id }, environment)
    end

    active_jobs.flatten.present?
  rescue StandardError => e
    Rails.logger.error "Exception caught while checking running jobs. Exception is #{e.inspect}"
    Rails.logger.error e.backtrace.join("\n")
  end

  def scheduled?
    if Rails.env.development?
      !HarvestSchedule.find_from_environment({ parser_id: self.id }, 'development').empty?
    else
      begin

        !HarvestSchedule.find_from_environment({ parser_id: self.id }, 'staging').empty? || !HarvestSchedule.find_from_environment({ parser_id: self.id }, 'production').empty?

      rescue StandardError => e

        Rails.logger.error "Exception caught while checking scheduled jobs. Exception is #{e.inspect}"
        Rails.logger.error e.backtrace.join("\n")

      end

    end
  end

  def xml?
    ['xml', 'oai', 'rss'].include?(strategy)
  end

  def json?
    strategy == 'json'
  end

  def oai?
    strategy == 'oai'
  end

  # Checks if the parser is valid or not.
  #
  # @author Eddie
  # @last_modified Eddie
  # @param environment [String]
  # @param version [Version]
  # @return [Boolean]
  def valid_parser?(environment, version = nil)
    self.content = version.content if version

    begin
      eval self.content
      true
    rescue => error
      self.error = { type: error.class, message: error.message }
      false
    rescue SyntaxError => error
      self.error = { type: error.class, message: error.message }
    end
  end

  # Returns an object of SupplejackCommon::Loader.
  # version parameter is added to update the content(parser script)
  # to the content of the current version. Else the loader will
  # Always process the last version of parser.
  #
  # @author Federico Gonzalez
  # @last_modified Eddie
  # @param environment [String]
  # @param version [Version]
  # @return [Object] the SupplejackCommon::Loader object
  def enrichment_definitions(environment, version = nil)
    if version
      self.content = version.content
    else
      env_versions = self.versions.where(tags: environment)
      self.content = env_versions.last.content if env_versions.any?
    end

    begin
      loader = SupplejackCommon::Loader.new(self, environment)

      if loader.loaded?
        loader.parser_class.enrichment_definitions
      else
        Rails.logger.error "parser not loaded: #{loader.load_error}"
        {}
      end
    rescue ScriptError => e
      Rails.logger.error "Syntax error ... Could not load parser: #{e.message}"
      {}
    rescue StandardError => e
      Rails.logger.error "Could not load parser: #{e.message}"
      {}
    end
  end

  def modes
    modes = ['normal']
    modes << 'incremental' if oai?
    modes << 'full_and_flush' if full_and_flush_allowed?
    modes.map { |m| [m, m.titleize] }
  end

  def partner
    source.try(:partner)
  end

  def full_and_flush_allowed?
    allow_full_and_flush
  end

  def update_last_editor
    self.last_editor = last_edited_by
  end

  def update_partner_name
    self.partner_name = source&.partner.name
  end

  def update_source_name
    self.source_name = source&.source_id
  end
end
