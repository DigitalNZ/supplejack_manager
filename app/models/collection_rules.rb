class CollectionRules
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :collection_title, type: String
  field :xpath, type: String
  field :status_codes, type: String
  field :active, type: Boolean, default: true
  field :throttle, type: Integer

  validates :collection_title, presence: true, uniqueness: true 
end
