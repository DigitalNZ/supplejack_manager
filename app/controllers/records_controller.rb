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