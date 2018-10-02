
class HomeController < ApplicationController
  def index
    @environment = params[:environment] || session[:environment] || APPLICATION_ENVS.first.to_s
    params[:environment] = @environment
    session[:environment] = @environment
    @stats = {active_jobs: 'n/a', finished_jobs: 'n/a', failed_jobs: 'n/a', activated: 'n/a', suppressed: 'n/a', deleted: 'n/a'}

    begin
      gather_job_stats
      # gather_collection_stats
      @parsers = Parser.desc(:updated_at).limit(5)
      # gather_harvest_schedules_stats
    rescue StandardError => e
      Rails.logger.error "Exception caught while gathering stats. Exception is #{e.inspect}"
      Rails.logger.error e.backtrace.join("\n")
      flash[:alert] = t('dashboard.error')
    end
  end

  private
    def gather_job_stats
      set_worker_environment_for(AbstractJob)

      since_when = DateTime.now - 1

      @stats[:active_jobs] = AbstractJob.find(:all, :from => :jobs_since, params: {:datetime => since_when, :environment => params[:environment], :status => "active"} ).count
      @stats[:finished_jobs] = AbstractJob.find(:all, :from => :jobs_since, params: {:datetime => since_when, :environment => params[:environment], :status => "finished"} ).count
      @stats[:failed_jobs] = AbstractJob.find(:all, :from => :jobs_since, params: {:datetime => since_when, :environment => params[:environment], :status => "failed"} ).count
    end

    def gather_collection_stats
      set_worker_environment_for(CollectionStatistics)

      klass = CollectionStatistics
      if klass.first
          @stats.merge!(klass.index_statistics([klass.first]).first.last)
      end

    end

    def gather_harvest_schedules_stats
      set_worker_environment_for(HarvestSchedule, params[:environment])
      @scheduled_jobs = HarvestSchedule.find(:all, :from => :next)
    end

end
