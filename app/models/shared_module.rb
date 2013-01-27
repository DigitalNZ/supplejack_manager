class SharedModule
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :name,      type: String
  field :content,   type: String
  field :user_id,   type: String

  def file_name
    @file_name ||= self.name.downcase.gsub(/\s/, "_") + ".rb"
  end

  def path
    "shared_modules/#{file_name}"
  end
end