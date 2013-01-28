class Parser
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :name,      type: String
  field :strategy,  type: String
  field :content,   type: String
  field :user_id,   type: String

  has_many :harvest_jobs

  VALID_STRATEGIES = ["json", "oai", "rss", "xml"]

  validates_presence_of   :name, :strategy, :content
  validates_inclusion_of  :strategy, in: VALID_STRATEGIES

  def file_name
    @file_name ||= self.name.downcase.gsub(/\s/, "_") + ".rb"
  end

  def path
    "#{strategy}/#{file_name}"
  end

  def fullpath
    ENV["PARSER_GIT_REPO_PATH"] + "/" + path
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
end