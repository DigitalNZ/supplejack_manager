class AbstractJobsController < ApplicationController

  before_filter :set_worker_environment

  def index
    @abstract_jobs = AbstractJob.search(params)
  end

  def set_worker_environment
    set_worker_environment_for(AbstractJob)
  end
end