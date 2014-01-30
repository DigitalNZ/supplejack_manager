class HomeController < ApplicationController

  def index
    @environment = params[:environment] || 'production'
    params[:environment] = @environment
    @stats = {active_jobs: 'n/a', finished_jobs: 'n/a', failed_jobs: 'n/a', activated: 'n/a', suppressed: 'n/a', deleted: 'n/a'}

    begin
      since_when = DateTime.now - 1

      @stats[:active_jobs] = AbstractJob.find(:all, :from => :jobs_since, params: {:datetime => since_when, :environment => params[:environment], :status => "active"} ).count
      @stats[:finished_jobs] = AbstractJob.find(:all, :from => :jobs_since, params: {:datetime => since_when, :environment => params[:environment], :status => "finished"} ).count
      @stats[:failed_jobs] = AbstractJob.find(:all, :from => :jobs_since, params: {:datetime => since_when, :environment => params[:environment], :status => "failed"} ).count

      set_worker_environment_for(CollectionStatistics)
      klass = CollectionStatistics
      if klass.first
          @stats.merge!(klass.index_statistics([klass.first]).first.last)
      end

      @parsers = Parser.desc(:updated_at).limit(5)
    
      @scheduled_jobs = HarvestSchedule.find(:all, :from => :next)
    rescue StandardError => e
      flash[:alert] = t('dashboard.error')
    end
    
  end
end
