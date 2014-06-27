# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

class ParserVersionSerializer < ActiveModel::Serializer

  attributes :id, :parser_id, :name, :strategy, :content, :message, :version, :file_name, :data_type

  def parser_id
    self.object.versionable.try(:id)
  end

  def data_type
    self.object.versionable.try(:data_type)
  end
end
