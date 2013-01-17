class GitStorage
  extend  ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_accessor :path, :data, :message
  attr_reader :name

  validates_presence_of :path, :data
  validates_format_of   :path, with: /^[a-z][a-z0-9_\/]+\.rb/

  def self.build(attributes={})
    storage = new(attributes[:path], attributes[:data])
    storage.instance_variable_set("@persisted", false)
    storage
  end

  def self.find(path)
    blob = THE_REPO.tree / path
    new(path, blob.data)
  end

  def self.all(directory="")
    objects = []
    directories = Array(directory)

    directories.each do |dir|
      storage = THE_REPO.tree / dir
      objects += storage.contents.map do |content|
        new("#{dir}/#{content.name}", content.data)
      end
    end

    objects
  end

  def initialize(path, data)
    @path = path
    @name = path.split("/")[1] if path
    @data = data
    @persisted = true
  end

  def persisted?
    @persisted
  end

  def save(message=nil, user=nil)
    if self.valid?
      THE_REPO.add(self.path, self.data)
      THE_REPO.commit(message, user)
      @persisted = true
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