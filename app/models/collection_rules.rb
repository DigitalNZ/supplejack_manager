class CollectionRules < ActiveResource::Base
  self.site = ENV["WORKER_HOST"]
  self.user = ENV["WORKER_API_KEY"]

  schema do
    attribute :collection_title, :string
    attribute :xpath,            :string
    attribute :status_codes,     :string
    attribute :active,           :boolean
    attribute :throttle,         :integer
  end

  include ActiveResource::SchemaTypes

  def id
    self._id
  end

end
