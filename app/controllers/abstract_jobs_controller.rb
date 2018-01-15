# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

# app/controllers/abstract_jobs_controller.rb
class AbstractJobsController < ApplicationController
  before_action :set_worker_environment

  def index
    @abstract_jobs = AbstractJob.search(
      status: abstract_job_params[:status],
      environment: abstract_job_params[:environment],
      page: abstract_job_params[:page],
      parser_id: abstract_job_params[:parser_id]
    )
  end

  def set_worker_environment
    set_worker_environment_for(AbstractJob)
  end

  private

  def abstract_job_params
    params.permit(:status, :environment, :page, :parser_id)
  end
end
