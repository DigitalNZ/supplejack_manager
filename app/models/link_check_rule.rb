class LinkCheckRule < ActiveResource::Base
  include EnvironmentHelpers
  
  self.site = ENV["WORKER_HOST"]
  self.user = ENV["WORKER_API_KEY"]

  schema do
    attribute :source_id,        :string
    attribute :xpath,            :string
    attribute :status_codes,     :string
    attribute :active,           :boolean
    attribute :throttle,         :integer
  end

  include ActiveResource::SchemaTypes

  def id
    self._id
  end

  def source
    Source.find self.source_id rescue nil
  end

end
