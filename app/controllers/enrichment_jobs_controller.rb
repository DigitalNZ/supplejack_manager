# frozen_string_literal: true

# app/controllers/enrichment_jobs_controller.rb
class EnrichmentJobsController < ApplicationController
  respond_to :js, :html
  before_action :set_worker_environment
  skip_before_action :verify_authenticity_token, only: [:show]

  def show
    @enrichment_job = EnrichmentJob.find(params[:id])
  end

  def create
    @enrichment_job = EnrichmentJob.new(enrichment_job_params)
    @enrichment_job.save
  end

  def update
    @enrichment_job = EnrichmentJob.find(params[:id])
    @enrichment_job.update_attributes(enrichment_job_params)
  end

  private
    def set_worker_environment
      set_worker_environment_for(EnrichmentJob)
    end

    def enrichment_job_params
      params.require(:enrichment_job).permit(:parser_id, :version_id,
                                             :user_id, :environment,
                                             :record_id, :enrichment,
                                             :status, :status_message)
    end
end
