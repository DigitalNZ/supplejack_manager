# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

class HarvestSchedulesController < ApplicationController
  authorize_resource

  before_action :set_worker_environment

  respond_to :html

  def index
    @harvest_schedules = HarvestSchedule.all

    @active_jobs = @harvest_schedules.map(&:status).include? 'active'
    @recurrent_schedules = @harvest_schedules.find_all {|s| s.recurrent == true }.sort_by(&:next_run_at)
    @one_off_schedules = @harvest_schedules.find_all {|s| s.recurrent == false }.sort_by(&:start_time)
  end

  def new
    @harvest_schedule = HarvestSchedule.new(params[:harvest_schedule] || {})
    @harvest_schedule.start_time = Time.now
    @harvest_schedule.environment = params[:environment]
    @harvest_schedule.mode = "normal"

    if can? :manage, HarvestSchedule
      @parsers = Parser.asc(:name)
    else
      @parsers = Parser.find_by_partners(current_user.manage_partners)
    end
  end

  def create
    @harvest_schedule = HarvestSchedule.new(params[:harvest_schedule])
    @harvest_schedule.save
    respond_with @harvest_schedule, location: harvest_schedules_path
  end

  def edit
    @harvest_schedule = HarvestSchedule.find(params[:id])

    if can? :manage, HarvestSchedule
      @parsers = Parser.asc(:name)
    else
      @parsers = Parser.find_by_partners(current_user.manage_partners)
    end
  end

  def update
    @harvest_schedule = HarvestSchedule.find(params[:id])

    @harvest_schedule.update_attributes(params[:harvest_schedule])
    redirect_to harvest_schedules_path
  end

  def update_all
    HarvestSchedule.all.select { |hs| %w(active stopped).include? hs.status }.each do |schedule|
      schedule.update_attributes(params[:harvest_schedule])
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
end
