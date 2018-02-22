
# app/controllers/abstract_jobs_controller.rb
class AbstractJobsController < ApplicationController
  before_action :set_worker_environment

  def index
    @abstract_jobs = AbstractJob.search(search_params)
  end

  def set_worker_environment
    set_worker_environment_for(AbstractJob)
  end

  private

  def search_params
    {
      status: nil,
      environment: nil,
      page: nil,
      parser_id: nil
    }.reverse_merge!(abstract_job_params)
      .compact
  end

  def abstract_job_params
    params.permit(:status, :environment, :page, :parser_id)
  end
end
