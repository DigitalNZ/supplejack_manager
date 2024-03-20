# frozen_string_literal: true

# app/models/parser_template.rb
class ParserTemplate
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :name,    type: String
  field :content, type: String
  field :user_id, type: String

  index({ name: 1 }, unique: true, name: 'parser_template_name_index')

  validates :name, :content, presence: true
  validates :name, uniqueness: true

  def self.find_by_name(name)
    where(name:).first
  end

  # Where first instead of find_by so that Mongo doesn't error
  # If the user does not exist
  def user
    User.where(id: user_id).first
  end
end
