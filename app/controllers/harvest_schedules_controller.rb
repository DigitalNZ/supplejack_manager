class HarvestSchedulesController < ApplicationController

  respond_to :html

  def index
    @harvest_schedules = HarvestSchedule.all
    @recurrent_schedules = @harvest_schedules.find_all {|s| s.recurrent == true }
    @one_off_schedules = @harvest_schedules.find_all {|s| s.recurrent == false }
  end

  def show
    @harvest_schedule = HarvestSchedule.find(params[:id])
  end

  def new
    @harvest_schedule = HarvestSchedule.new
    @harvest_schedule.start_time = Time.now
  end

  def create
    @harvest_schedule = HarvestSchedule.new(params[:harvest_schedule])
    @harvest_schedule.save
    respond_with @harvest_schedule, location: harvest_schedules_path
  end

  def edit
    @harvest_schedule = HarvestSchedule.find(params[:id])
  end

  def update
    @harvest_schedule = HarvestSchedule.find(params[:id])
    @harvest_schedule.update_attributes(params[:harvest_schedule])
    redirect_to harvest_schedules_path
  end

  def destroy
    @harvest_schedule = HarvestSchedule.find(params[:id])
    @harvest_schedule.destroy
    redirect_to harvest_schedules_path
  end
end