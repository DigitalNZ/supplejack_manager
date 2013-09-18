class EnrichmentJobsController < ApplicationController

  respond_to :js, :html

  before_filter :set_worker_environment

  def show
    @enrichment_job = EnrichmentJob.find(params[:id])
  end

  def create
    @enrichment_job = EnrichmentJob.new(params[:enrichment_job])
    @enrichment_job.save
  end

  def update
    @enrichment_job = EnrichmentJob.find(params[:id])
    @enrichment_job.update_attributes(params[:enrichment_job])
  end

  def set_worker_environment
    set_worker_environment_for(EnrichmentJob)
  end
end
