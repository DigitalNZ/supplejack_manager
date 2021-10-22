# frozen_string_literal: true

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

  def self.custom_find(id)
    any_of({ id: id }, { source_id: id }).first
  end

  def partner_name
    partner.name
  end

  private
    def update_apis
      partner.update_apis
      APPLICATION_ENVS.each do |env|
        Api::PartnerSources.post(env, self.partner.id, { source: self.attributes })
      end
    end

    def create_link_check_rule
      APPLICATION_ENVS.each do |environment|
        set_worker_environment_for(LinkCheckRule, environment)
        LinkCheckRule.create(source_id: self.id, active: false)
      end
    end

    def slugify_source_id
      # Convert any special characters to underscore except hyphens
      self.source_id = source_id.split('-').map(&:parameterize).map(&:underscore).join('-')
    end
end
