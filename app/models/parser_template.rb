# The majority of the Supplejack code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components licensed under the GPL or MIT licenses or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

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