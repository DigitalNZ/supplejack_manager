# frozen_string_literal: true

class Version
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  # include Mongoid::Paranoia
  include Mongoid::Attributes::Dynamic

  field :content,   type: String
  field :tags,      type: Array
  field :message,   type: String
  field :version,   type: Integer

  belongs_to :user

  embedded_in :versionable, polymorphic: true
  delegate :name, :strategy, :file_name, to: :versionable

  def staging?
    self.tags ||= []
    self.tags.include?('staging')
  end

  def production?
    self.tags ||= []
    self.tags.include?('production')
  end

  def update_attributes(attributes = {})
    attributes ||= {}
    attributes[:tags] ||= []
    super(attributes)
  end

  def post_changes
    if self.production? && ENV['CHANGESAPP_HOST'].present?
      payload = changes_payload

      RestClient::Request.execute(
        method: :post,
        url: ENV['CHANGESAPP_HOST'],
        user: ENV['CHANGESAPP_USER'],
        password: ENV['CHANGESAPP_PASSWORD'],
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
