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
    BACKEND_ENVIRONMENTS.each do |environment|
      env = Figaro.env(environment)
      RestClient.post("#{env['API_HOST']}/partners", partner: self.attributes)
    end
  end
end
