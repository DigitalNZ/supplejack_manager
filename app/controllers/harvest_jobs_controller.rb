class HarvestJobsController < ApplicationController

  def index
    @harvest_jobs = HarvestJob.search(params)
  end

  def show
    @harvest_job = HarvestJob.find(params[:id])
  end

  def create
    @harvest_job = HarvestJob.new(params[:harvest_job])
    @harvest_job.save
  end

  def update
    @harvest_job = HarvestJob.find(params[:id])
    @harvest_job.update_attributes(params[:harvest_job])
  end
end