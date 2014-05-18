# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

class Snippet
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  include Versioned

  field :content,   type: String

  def self.find_by_name(name, environment)
    snippet = where(name: name).first
    snippet.current_version(environment) if snippet.present?
  end

  def file_name
    @file_name ||= self.name.downcase.gsub(/\s/, "_") + ".rb"
  end

  def path
    "snippets/#{file_name}"
  end
end
