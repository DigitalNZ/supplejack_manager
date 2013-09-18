class Parser
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include ActiveModel::SerializerSupport

  include TemplateHelpers

  include Versioned

  field :strategy,  type: String
  field :content,   type: String

  attr_accessor :parser_template_name

  belongs_to :source
  accepts_nested_attributes_for :source
  validates :source, presence: true, associated: true

  VALID_STRATEGIES = ["json", "oai", "rss", "xml", "tapuhi"]

  # ENVIRONMENTS = [:staging, :production]

  validates_presence_of   :name, :strategy
  validates_uniqueness_of :name
  validates_inclusion_of  :strategy, in: VALID_STRATEGIES

  before_create :apply_parser_template!

  before_destroy { |parser| HarvestSchedule.destroy_all_for_parser(parser.id) }

  def file_name
    @file_name ||= self.name.downcase.gsub(/\s/, "_") + ".rb"
  end

  def path
    "#{strategy}/#{file_name}"
  end

  def running_jobs?
    if Rails.env.development?
      !AbstractJob.search({parser_id: self.id}, 'development').empty?
    else
      !AbstractJob.search({parser_id: self.id}, 'staging').empty? or !AbstractJob.search({parser_id: self.id}, 'production').empty?
    end
  end

  def scheduled?
    if Rails.env.development?
      !HarvestSchedule.find_from_environment({parser_id: self.id}, 'development').empty?
    else
      !HarvestSchedule.find_from_environment({parser_id: self.id}, 'staging').empty? or !HarvestSchedule.find_from_environment({parser_id: self.id}, 'production').empty?
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

  def enrichment_definitions(environment)
    begin
      loader = HarvesterCore::Loader.new(self, environment)

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
    modes = ['normal','full_and_flush']
    modes << 'incremental' if oai?
    modes.map {|m| [m.titleize, m]}
  end

  def partner
    source.try(:partner)
  end

end
