class ParserTemplate
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :name,		type: String
  field :content, type: String
  field :user_id, type: String

  index({ name: 1 }, { unique: true, name: "parser_template_name_index" })

  validates :name, :content, presence: true
  validates :name, uniqueness: true

  def self.find_by_name(name)
    where(name: name).first
  end
end