class Parser
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  VALID_STRATEGIES = ["json", "oai", "rss", "xml"]

  class << self
    def build
      
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

  attr_reader :blob, :strategy, :name
  attr_accessor :data, :message

  def initialize(blob, strategy)
    @blob = blob
    @name = blob.name
    @data = blob.data
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

  def save(message=nil)
    THE_REPO.add(self.path, self.data)
    THE_REPO.commit(message)
  end

  def update_attributes(attributes={})
    attributes = attributes.symbolize_keys
    self.data = attributes[:data]
    self.save(attributes[:message])
  end
end