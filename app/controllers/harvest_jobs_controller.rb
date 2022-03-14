# frozen_string_literal: true

# app/controllers/harvest_jobs_controller.rb
class HarvestJobsController < ApplicationController
  respond_to :js, :html
  skip_before_action :verify_authenticity_token

  before_action :set_worker_environment

  def show
    @harvest_job = HarvestJob.find(params[:id])
  end

  def create
    @harvest_job = HarvestJob.new(harvest_job_params)
    @harvest_job.save

    respond_to :js
  end

  def update
    @harvest_job = HarvestJob.find(params[:id])
    @harvest_job.update_attributes(harvest_job_params)
  end

  private
    def set_worker_environment
      set_worker_environment_for(HarvestJob)
    end

    def harvest_job_params
      params.require(:harvest_job).permit(:parser_id, :version_id, :source_id, :user_id, :environment, :mode, :limit, :status, :status_message, enrichments: [])
    end
end
