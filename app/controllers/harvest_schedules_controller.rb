# frozen_string_literal: true

class HarvestSchedulesController < ApplicationController
  authorize_resource

  before_action :find_parsers, only: %i[new create edit update]
  before_action :set_worker_environment
  skip_before_action :verify_authenticity_token

  respond_to :html

  def index
    @harvest_schedules = HarvestSchedule.all

    @active_jobs = @harvest_schedules.map(&:status).include? 'active'
    @recurrent_schedules = @harvest_schedules.find_all { |s| s.recurrent == true }.sort_by(&:next_run_at)
    @one_off_schedules = @harvest_schedules.find_all { |s| s.recurrent == false }.sort_by(&:start_time)
  end

  def new
    # This is because this route is shared with the new.js template.
    if params[:harvest_schedule].present?
      @harvest_schedule = HarvestSchedule.new(harvest_schedule_params)
    else
      @harvest_schedule = HarvestSchedule.new
    end

    @harvest_schedule.start_time = Time.now
    @harvest_schedule.environment = params[:environment]
    @harvest_schedule.mode = 'normal'
  end

  def create
    @harvest_schedule = HarvestSchedule.new(harvest_schedule_params)
    @harvest_schedule.save
    respond_with @harvest_schedule, location: harvest_schedules_path
  end

  def edit
    @harvest_schedule = HarvestSchedule.find(params[:id])
  end

  def update
    @harvest_schedule = HarvestSchedule.find(params[:id])

    @harvest_schedule.update_attributes(harvest_schedule_params)
    redirect_to harvest_schedules_path
  end

  def update_all
    HarvestSchedule.all.select { |hs| %w(active stopped).include? hs.status }.each do |schedule|
      schedule.update_attributes(harvest_schedule_params)
    end

    flash[:notice] = "All scheduled harvests are now #{params[:harvest_schedule][:status]}"

    redirect_to harvest_schedules_path
  end

  def destroy
    @harvest_schedule = HarvestSchedule.find(params[:id])
    @harvest_schedule.destroy
    redirect_to harvest_schedules_path
  end

  def set_worker_environment
    set_worker_environment_for(HarvestSchedule)
  end

  private
    def harvest_schedule_params
      params
        .require(:harvest_schedule)
        .moderate(controller_name, action_name, :parser_id, :start_time, :cron, :frequency, :at_hour, :at_minutes, :offset, :environment, :recurrent, :mode, :enrichments, :status)
    end

    def find_parsers
      if can? :manage, HarvestSchedule
        @parsers = Parser.asc(:name)
      else
        @parsers = Parser.find_by_partners(current_user.manage_partners)
      end
    end
end
