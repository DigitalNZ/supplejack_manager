class HarvestJobsController < ApplicationController

  before_filter :authenticate_user!
  
  def create
    @harvest_job = HarvestJob.new(params[:harvest_job])
    @harvest_job.save
  end

  def show
    @harvest_job = HarvestJob.find(params[:id])
  end
end