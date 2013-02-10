class Snippet
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :name,      type: String
  field :content,   type: String
  field :user_id,   type: String

  def self.find_by_name(name)
    where(name: name).first
  end

  def file_name
    @file_name ||= self.name.downcase.gsub(/\s/, "_") + ".rb"
  end

  def path
    "snippets/#{file_name}"
  end
end