# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

class Partner
  include Mongoid::Document

  has_many :sources
  
  field :name, type: String

  validates :name, presence: true, uniqueness: true

  after_save :update_apis

  default_scope order_by(name: :asc)

  def self.for_select
    return [] if Partner.all.empty?
    Partner.all.sort(name: 1).map do |partner|
      [partner.name, partner.sources.map {|p| [p.name, p.id]}]
    end
  end

  def update_apis
    APPLICATION_ENVS.each do |environment|
      env = Figaro.env(environment)

      RestClient.post("#{env['API_HOST']}/harvester/partners", { partner: self.attributes, api_key: env['HARVESTER_API_KEY'] })
    end
  end
end
