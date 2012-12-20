class Parser
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  VALID_STRATEGIES = ["json", "oai", "rss", "xml"]

  validates_presence_of   :name, :strategy, :data
  validates_format_of     :name, with: /^[a-z][a-z0-9_]+\.rb/
  validates_inclusion_of  :strategy, in: VALID_STRATEGIES

  class << self
    def build(attributes={})
      attributes = attributes.try(:symbolize_keys) || {}
      parser = self.new(nil, attributes[:strategy])
      parser.name = attributes[:name]
      parser.data = attributes[:data]
      parser
    end

    def find(path)
      path.gsub!(/-/, "/")
      blob = THE_REPO.tree / path
      segments = path.split("/")
      new(blob, segments[0])
    end

    def all
      parsers = []
      THE_REPO.tree.contents.each do |content|
        if content.respond_to?(:contents) && VALID_STRATEGIES.include?(content.name)
          content.contents.each do |blob|
            parsers << Parser.new(blob, content.name)
          end
        end
      end

      parsers
    end
  end

  attr_reader :blob
  attr_accessor :data, :strategy, :name, :message

  def initialize(blob, strategy)
    @blob = blob

    if blob
      @name = blob.name
      @data = blob.data
    end

    @strategy = strategy
  end

  def id
    "#{strategy}-#{name}"
  end

  def to_param
    self.id
  end

  def persisted?
    blob.present?
  end

  def path
    "#{strategy}/#{name}"
  end

  def fullpath
    ENV["PARSER_GIT_REPO_PATH"] + "/" + path
  end

  def save(message=nil, user=nil)
    if self.valid?
      THE_REPO.add(self.path, self.data)
      THE_REPO.commit(message, user)
    else
      return false
    end
  end

  def update_attributes(attributes={}, user=nil)
    attributes = attributes.symbolize_keys
    self.data = attributes[:data]
    self.save(attributes[:message], user)
  end
end