# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

class EnrichmentJobsController < ApplicationController

  respond_to :js, :html

  before_filter :set_worker_environment

  def show
    @enrichment_job = EnrichmentJob.find(params[:id])
  end

  def create
    @enrichment_job = EnrichmentJob.new(params[:enrichment_job])
    @enrichment_job.save
  end

  def update
    @enrichment_job = EnrichmentJob.find(params[:id])
    @enrichment_job.update_attributes(params[:enrichment_job])
  end

  def set_worker_environment
    set_worker_environment_for(EnrichmentJob)
  end
end
