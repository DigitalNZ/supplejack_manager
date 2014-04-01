class Source
  include Mongoid::Document

  belongs_to :partner

  field :name, type: String
  field :source_id, type: String

  validates :name, presence: true
  validates :source_id, presence: true, uniqueness: true
  validates :partner, presence: true, associated: true

  accepts_nested_attributes_for :partner

  after_save :update_apis
  after_create :create_link_check_rule

  def partner_name
    partner.name
  end

  private
  
  def update_apis
    partner.update_apis
    BACKEND_ENVIRONMENTS.each do |environment|
      env = Figaro.env(environment)
      RestClient.post("#{env['API_HOST']}/partners/#{self.partner.id.to_s}/sources", source: self.attributes)
    end
  end

  def create_link_check_rule
    BACKEND_ENVIRONMENTS.each do |environment|
      env = Figaro.env(environment)
      LinkCheckRule.create(source_id: self.source_id, active: false)
    end
  end
end
