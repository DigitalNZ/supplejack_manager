class CollectionRules
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :collection_title, type: String
  field :xpath, type: String
  field :status_codes, type: String

  validates :collection_title, presence: true
end
