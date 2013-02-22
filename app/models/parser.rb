class Parser
  include Mongoid::Document
  include Mongoid::Timestamps

  include ActiveModel::SerializerSupport

  field :name,      type: String
  field :strategy,  type: String
  field :content,   type: String

  attr_accessor :message, :tags, :user_id

  embeds_many :versions, class_name: "ParserVersion"

  VALID_STRATEGIES = ["json", "oai", "rss", "xml", "tapuhi"]

  ENVIRONMENTS = [:staging, :production]

  validates_presence_of   :name, :strategy, :content
  validates_inclusion_of  :strategy, in: VALID_STRATEGIES

  def file_name
    @file_name ||= self.name.downcase.gsub(/\s/, "_") + ".rb"
  end

  def path
    "#{strategy}/#{file_name}"
  end

  def loader
    @loader ||= ParserLoader.new(self)
  end

  def load_file
    loader.load_parser
  end

  def xml?
    ["xml", "oai", "rss"].include?(strategy)
  end

  def json?
    strategy == "json"
  end

  def current_version(environment)
    self.versions.where(tags: environment.to_s).desc(:created_at).first
  end

  def save_with_version
    result = self.save

    if result
      version_number = self.versions.count + 1
      self.versions.create(content: content, tags: tags, message: message, user_id: user_id, version: version_number)
    end

    result
  end

  def find_version(version_id)
    self.versions.find(version_id)
  end

end