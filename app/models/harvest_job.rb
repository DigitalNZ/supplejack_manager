class HarvestJob < ActiveResource::Base
  
  self.site = ENV["WORKER_HOST"]
  self.user = ENV["WORKER_API_KEY"]

  add_response_method :http

  def self.from_parser(parser, user=nil)
    self.new(parser_id: parser.id, limit: nil, user_id: user.try(:id))
  end

  def self.search(params={})
    params = params.try(:dup).try(:symbolize_keys) || {}
    params.reverse_merge!(status: "active", page: 1)
    harvest_jobs = self.find(:all, params: {status: params[:status], page: params[:page]})
    Kaminari::PaginatableArray.new(
      harvest_jobs,{
        limit: harvest_jobs.http['X-limit'].to_i,
        offset: harvest_jobs.http['X-offset'].to_i,
        total_count: harvest_jobs.http['X-total'].to_i
    })
  end

  def user
    @user ||= begin
      User.find(self.user_id) if self.respond_to?(:user_id)
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end
  end

  def parser
    @parser ||= begin
      Parser.find(self.parser_id) if self.respond_to?(:parser_id)
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end
  end

  def finished?
    self.status == "finished"
  end

  def start_time
    value = super
    if value.is_a?(String)
      value = value.present? ? Time.parse(value) : nil
    end
    value
  end

  def end_time
    value = super
    if value.is_a?(String)
      value = value.present? ? Time.parse(value) : nil
    end
    value
  end
end