class Parser < GitStorage
  VALID_STRATEGIES = ["json", "oai", "rss", "xml"]

  validates_presence_of   :strategy
  validates_inclusion_of  :strategy, in: VALID_STRATEGIES

  class << self
    def build(attributes={})
      path = [attributes[:strategy], attributes[:name]].join("/")
      super(path: path, data: attributes[:data])
    end

    def find(path)
      path.gsub!(/-/, "/")
      super(path)
    end

    def all
      super(["xml", "rss", "oai", "json"])
    end
  end

  attr_accessor :strategy

  def initialize(path, data)
    super(path, data)

    @strategy = path.split("/").first if path.present?
  end

  def id
    "#{strategy}-#{name}"
  end

  def fullpath
    ENV["PARSER_GIT_REPO_PATH"] + "/" + path
  end

  def loader
    @loader ||= ParserLoader.new(self)
  end

  def load
    loader.load_parser
  end

  def xml?
    ["xml", "oai", "rss"].include?(strategy)
  end

  def json?
    strategy == "json"
  end
end