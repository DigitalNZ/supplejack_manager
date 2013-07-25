class CollectionStatisticsController < ApplicationController

	respond_to :html

	before_filter :set_worker_environment

	def index
		klass = CollectionStatistics
		@collection_statistics = klass.index_statistics(klass.all)
		respond_with @collection_statistics
	end

	def show
		@day = params[:id]
		@collection_statistics = CollectionStatistics.find(:all, params: {collection_statistics: { day: @day }})
		respond_with @collection_statistics
	end

	def set_worker_environment
    set_worker_environment_for(CollectionStatistics)
  end
end