# frozen_string_literal: true

# app/controllers/harvest_jobs_controller.rb
class HarvestJobsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_worker_environment

  def show
    @harvest_job = HarvestJob.find(params[:id])

    respond_to do |format|
      format.html { render :show }
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(@harvest_job, partial: 'harvest_jobs/harvest_job')
      }
    end
  end

  def create
    @harvest_job = HarvestJob.new(harvest_job_params)

    if @harvest_job.save
      render turbo_stream: turbo_stream.replace('harvest_job_form', partial: 'harvest_jobs/harvest_poll')
    else
      render turbo_stream: turbo_stream.replace(@harvest_job, partial: 'harvest_jobs/form')
    end
  end

  def update
    @harvest_job = HarvestJob.find(params[:id])
    @harvest_job.update_attributes(harvest_job_params)

    redirect_to environment_harvest_job_path(params[:environment], id: @harvest_job.id)
  end

  private
    def set_worker_environment
      set_worker_environment_for(HarvestJob)
    end

    def harvest_job_params
      params.require(:harvest_job).permit(:parser_id, :version_id, :user_id, :environment, :mode, :limit, :status, :status_message, enrichments: [])
    end
end
