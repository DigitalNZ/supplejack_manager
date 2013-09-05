class Partner
  include Mongoid::Document

  has_many :sources
  
  field :name, type: String

  validates :name, presence: true, uniqueness: true

  after_save :update_apis

  def update_apis
    BACKEND_ENVIRONMENTS.each do |environment|
      env = Figaro.env(environment)
      RestClient.post("#{env['API_HOST']}/partners", partner: self.attributes)
    end
  end
end
