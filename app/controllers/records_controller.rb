# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

class RecordsController < ApplicationController
  
  before_filter :find_parser

  def index
    params[:environment] ||= 'staging'
    set_worker_environment_for(HarvestJob)

    @previewer = Previewer.new(@parser, params[:parser][:content], current_user.id, params[:index], params[:review])
    @previewer.create_preview_job

    @preview_id = @previewer.preview_id

    render layout: false
  end

  def find_parser
    @parser = Parser.find(params[:parser_id])
  end
end