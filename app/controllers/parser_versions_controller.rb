class ParserVersionsController < ApplicationController

  before_filter :find_parser_and_version

  respond_to :html, :json

  def show
    @harvest_job = HarvestJob.build(parser_id: @parser.id, version_id: @version.id, user_id: current_user.id)
    respond_with @version
  end

  def update
    @version.update_attributes(params[:version])
    redirect_to parser_parser_version_path(@parser, @version)
  end

  def find_parser_and_version
    @parser = Parser.find(params[:parser_id])
    @version = @parser.find_version(params[:id])
  end
  
end