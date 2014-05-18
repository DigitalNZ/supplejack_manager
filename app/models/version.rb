# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

class Version

  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Paranoia
  include ActiveModel::SerializerSupport

  field :content,   type: String
  field :tags,      type: Array
  field :message,   type: String
  field :version,   type: Integer

  belongs_to :user

  embedded_in :versionable, polymorphic: true
  delegate :name, :strategy, :file_name, to: :versionable

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

  def post_changes
    if self.production? && ENV['CHANGESAPP_HOST'].present?
      payload = changes_payload

      RestClient::Request.execute(
        method: :post,
        url: ENV["CHANGESAPP_HOST"],
        user: ENV["CHANGESAPP_USER"],
        password: ENV["CHANGESAPP_PASSWORD"],
        payload: payload
      )
    end
  end

  def changes_payload
    {
      component: "DNZ Harvester - #{self.versionable.class.name}",
      description: "#{self.name}: #{self.message}",
      email: self.user.email,
      time: Time.now,
      environment: Rails.env,
      revision: self.version
    }
  end
end
