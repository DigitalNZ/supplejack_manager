class ParserVersionsController < ApplicationController

  before_filter :find_parser_and_version

  def show
    @harvest_job = HarvestJob.from_parser(@parser, current_user)
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