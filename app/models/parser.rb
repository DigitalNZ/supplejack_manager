
class Parser
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Attributes::Dynamic

  include TemplateHelpers

  include Versioned

  field :strategy,  type: String
  field :content,   type: String
  field :data_type, type: String, default: "record"
  field :allow_full_and_flush, type: Boolean, default: true

  index(name: 1) # requires this index as parsers are sorted with name in controller

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

  def parser_name_is_a_valid_class_name
    errors.add(:name, 'Your Parser Name includes invalid characters. Please remove the /.') if name.include? '/'
    class_name.constantize
  rescue NameError => e
    if e.message.include? 'wrong constant name'
      errors.add(:name, 'Parser name includes invalid characters. The name can only contain Alphabetical or Numeric characters, and can not start with a number.')
    end
  end

  def self.find_by_partners(partner_ids=[])
    sources = Source.where(:partner.in => partner_ids).pluck(:id)
    @parsers = Parser.where(:source.in => sources)
  end

  def class_name
    name.gsub(/\s/, '').camelize
  end

  def file_name
    @file_name ||= name.downcase.gsub(/\s/, '_') + ".rb"
  end

  def path
    "#{strategy}/#{file_name}"
  end

  def running_jobs?
    begin
      active_jobs = []
      APPLICATION_ENVS.each do |environment|
        active_jobs << AbstractJob.search({parser_id: self.id}, environment)
      end

      active_jobs.flatten.present?
    rescue StandardError => e
      Rails.logger.error "Exception caught while checking running jobs. Exception is #{e.inspect}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end

  def scheduled?
    if Rails.env.development?
      !HarvestSchedule.find_from_environment({parser_id: self.id}, 'development').empty?
    else
      begin

        !HarvestSchedule.find_from_environment({parser_id: self.id}, 'staging').empty? or !HarvestSchedule.find_from_environment({parser_id: self.id}, 'production').empty?

      rescue StandardError => e

        Rails.logger.error "Exception caught while checking scheduled jobs. Exception is #{e.inspect}"
        Rails.logger.error e.backtrace.join("\n")

      end

    end
  end

  def xml?
    ["xml", "oai", "rss"].include?(strategy)
  end

  def json?
    strategy == "json"
  end

  def oai?
    strategy == "oai"
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
    modes.map {|m| [m.titleize, m]}
  end

  def partner
    source.try(:partner)
  end

  def full_and_flush_allowed?
    allow_full_and_flush
  end
end
