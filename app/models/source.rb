
class Source
  include Mongoid::Document
  include EnvironmentHelpers

  belongs_to :partner

  field :source_id, type: String

  validates :source_id, presence: true, uniqueness: true
  validates :partner,   presence: true, associated: true

  accepts_nested_attributes_for :partner

  after_create :create_link_check_rule

  after_save :update_apis

  before_save :slugify_source_id

  def partner_name
    partner.name
  end

  private

  def update_apis
    partner.update_apis
    APPLICATION_ENVS.each do |environment|
      env = APPLICATION_ENVIRONMENT_VARIABLES[environment]
      RestClient.post("#{env['API_HOST']}/harvester/partners/#{self.partner.id.to_s}/sources", { source: self.attributes, api_key: env['HARVESTER_API_KEY'] })
    end
  end

  def create_link_check_rule
    APPLICATION_ENVS.each do |environment|
      set_worker_environment_for(LinkCheckRule, environment)
      LinkCheckRule.create(source_id: self.id, active: false)
    end
  end

  def slugify_source_id
    self.source_id = source_id.parameterize.underscore
  end
end
