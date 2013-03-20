class ParserVersionsController < ApplicationController

  before_filter :find_parser
  before_filter :find_version, only: [:show, :update]

  respond_to :html, :json

  def current
    @version = @parser.current_version(params[:environment])
    respond_with @version
  end

  def show
    @harvest_job = HarvestJob.build(parser_id: @parser.id, version_id: @version.id, user_id: current_user.id)
    @enrichment_job = EnrichmentJob.build(parser_id: @parser.id, version_id: @version.id, user_id: current_user.id)
    respond_with @version
  end

  def update
    @version.update_attributes(params[:version])
    redirect_to parser_parser_version_path(@parser, @version)
  end

  def find_parser
    @parser = Parser.find(params[:parser_id])
  end

  def find_version
    @version = @parser.find_version(params[:id])
  end
  
end