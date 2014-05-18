# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

class Source
  include Mongoid::Document
  include EnvironmentHelpers

  belongs_to :partner

  field :name, type: String
  field :source_id, type: String

  validates :name,      presence: true, uniqueness: true
  validates :source_id, presence: true, uniqueness: true
  validates :partner,   presence: true, associated: true

  accepts_nested_attributes_for :partner

  before_validation :create_source_id

  after_create :create_link_check_rule

  after_save :update_apis

  def partner_name
    partner.name
  end

  private
  
  def update_apis
    partner.update_apis
    APPLICATION_ENVS.each do |environment|
      env = Figaro.env(environment)
      RestClient.post("#{env['API_HOST']}/partners/#{self.partner.id.to_s}/sources", source: self.attributes)
    end
  end

  def create_link_check_rule
    APPLICATION_ENVS.each do |environment|
      set_worker_environment_for(LinkCheckRule, environment)
      LinkCheckRule.create(source_id: self.id, active: false)
    end
  end
  
  def create_source_id
    self.source_id = self.name.gsub(/[^0-9a-z ]/i, '').split.join("_").downcase unless self.source_id.present?
  end
end
