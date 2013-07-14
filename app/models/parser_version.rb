class ParserVersion
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Paranoia

  include ActiveModel::SerializerSupport

  field :content,   type: String
  field :tags,      type: Array
  field :message,   type: String
  field :version,   type: Integer

  embedded_in :parser

  delegate :name, :strategy, :file_name, to: :parser

  belongs_to :user

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
    if self.production?
      payload = {
        component: "DNZ Harvester configs",
        description: "#{self.name}: #{self.message}",
        email: self.user.email,
        time: Time.now,
        environment: Rails.env,
        revision: self.version
      }

      RestClient::Request.execute(
        method: :post,
        url: ENV["CHANGESAPP_HOST"],
        user: ENV["CHANGESAPP_USER"],
        password: ENV["CHANGESAPP_PASSWORD"],
        payload: payload
      )
    end
  end
end