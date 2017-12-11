# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

# app/controllers/collection_statistics_controller.rb
class CollectionStatisticsController < ApplicationController
  respond_to :html
  before_action :set_worker_environment

  def index
    klass = CollectionStatistics
    @collection_statistics = klass.index_statistics(klass.all)
    respond_with @collection_statistics
  end

  def show
    @day = params[:id]
    @collection_statistics = CollectionStatistics.find(:all, params: { collection_statistics: { day: @day } })
    respond_with @collection_statistics
  end

  def set_worker_environment
    set_worker_environment_for(CollectionStatistics)
  end
end
