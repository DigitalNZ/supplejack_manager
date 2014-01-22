class HomeController < ApplicationController

  def index
    @environment = params[:environment] || 'production'
    params[:environment] = @environment
    @stats = {active_jobs: 0, completed_jobs: 0, failed_jobs: 0, activated: 0, suppressed: 0, deleted: 0}

    begin
      @stats[:active_jobs] = AbstractJob.search(environment: params[:environment], status: 'active').count
      @stats[:completed_jobs] = AbstractJob.search(environment: params[:environment], status: 'completed').count
      @stats[:failed_jobs] = AbstractJob.search(environment: params[:environment], status: 'failed').count

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
