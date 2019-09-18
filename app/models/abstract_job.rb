
class AbstractJob < ActiveResource::Base
  include EnvironmentHelpers

  self.site = ENV['WORKER_HOST']
  headers['Authorization'] = "Token token=#{ENV['WORKER_KEY']}"

  schema do
    attribute :_type,                 :string
    attribute :start_time,            :datetime
    attribute :end_time,              :datetime
    attribute :records_count,         :integer
    attribute :processed_count,       :integer
    attribute :throughput,            :float
    attribute :duration,              :float
    attribute :status,                :string
    attribute :status_message,        :string
    attribute :user_id,               :string
    attribute :parser_id,             :string
    attribute :version_id,            :string
    attribute :harvest_schedule_id,   :string
    attribute :environment,           :string
    attribute :failed_records_count,  :integer
    attribute :invalid_records_count, :integer
    attribute :created_at,            :datetime
    attribute :updated_at,            :datetime
    attribute :incremental,           :boolean
    attribute :enrichments,           :string
    attribute :last_posted_record_id, :string
  end

  include ActiveResource::SchemaTypes

  add_response_method :http

  class << self
    def build(attributes={})
      attributes.reverse_merge!({parser_id: nil, version_id: nil, user_id: nil, limit: nil, environment: nil})
      new(attributes)
    end

    def from_parser(parser, user=nil)
      self.new(parser_id: parser.id, version_id: nil, limit: nil, user_id: user.try(:id), environment: nil)
    end

    def search(params={}, environment = nil)
      self.change_worker_env!(environment) if environment.present?
      params = params.try(:dup).try(:symbolize_keys) || {}
      params.reverse_merge!(status: "active", page: 1, environment: ["staging","production"])
      params[:parser_id] = params.delete(:parser) if params[:parser]
      jobs = self.find(:all, params: params)
      Kaminari::PaginatableArray.new(
        jobs,{
          limit: jobs.http['X-limit'].to_i,
          offset: jobs.http['X-offset'].to_i,
          total_count: jobs.http['X-total'].to_i
      })
    end
  end

  # Parser collection has too many embeded documents due to
  # parser versions.
  # This method returns only the name attribute to be displayed
  # along with the AbstractJob details
  def parser_name
    Parser.only(:name).find(parser_id).name
  rescue Mongoid::Errors::DocumentNotFound
    ''
  end

  def user
    @user ||= begin
      User.find(self.user_id) if self.respond_to?(:user_id) && user_id.present?
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end
  end

  def parser
    @parser ||= begin
      Parser.find(self.parser_id) if self.respond_to?(:parser_id) && parser_id.present?
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end
  end

  def harvest_schedule
    @harvest_schedule ||= begin
      HarvestSchedule.find(self.harvest_schedule_id) if self.respond_to?(:harvest_schedule_id) && harvest_schedule_id.present?
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end
  end

  def finished?
    status == 'finished'
  end

  def total_errors_count
    failed_records_count.to_i + invalid_records_count.to_i
  end
end
