class ParserVersionsController < ApplicationController

  before_filter :find_parser
  before_filter :find_version, only: [:show, :update, :new_enrichment, :new_harvest]

  respond_to :html, :json, :js

  def current
    @version = @parser.current_version(params[:environment])
    respond_with @version, serializer: ParserVersionSerializer
  end

  def show
    @harvest_job = HarvestJob.build(parser_id: @parser.id, version_id: @version.id, user_id: current_user.id)
    @enrichment_job = EnrichmentJob.build(parser_id: @parser.id, version_id: @version.id, user_id: current_user.id)
    respond_with @version, serializer: ParserVersionSerializer
  end

  def update
    @version.update_attributes(params[:version])
    @version.post_changes
    redirect_to parser_parser_version_path(@parser, @version)
  end

  def new_enrichment
    @enrichment_job = EnrichmentJob.new(parser_id: @parser.id,
                                        version_id: @version.id,
                                        user_id: current_user.id,
                                        environment: params[:environment])
  end

  def new_harvest
    @harvest_job = HarvestJob.new(parser_id: @parser.id,
                                  version_id: @version.id,
                                  user_id: current_user.id,
                                  environment: params[:environment])
  end

  private

  def find_parser
    @parser = Parser.find(params[:parser_id])
  end

  def find_version
    @version = @parser.find_version(params[:id])
  end

end
