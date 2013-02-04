class ParserVersion
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :content,   type: String
  field :tags,      type: Array
  field :message,   type: String
  field :version,   type: Integer

  embedded_in :parser

  belongs_to :user

  def staging?
    self.tags ||= []
    self.tags.include?("staging")
  end

  def production?
    self.tags ||= []
    self.tags.include?("production")
  end

  def update_attributes(attributes={})
    attributes ||= {}
    attributes[:tags] ||= []
    super(attributes)
  end
end