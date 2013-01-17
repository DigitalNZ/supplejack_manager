class SharedModule < GitStorage

  def self.build(attributes={})
    name = attributes.delete(:name)
    super(attributes.merge(path: "shared_modules/#{name}"))
  end

  def self.find(name)
    super("shared_modules/#{name}")
  end

  def self.all
    super("shared_modules")
  end

  def id
    name
  end
end