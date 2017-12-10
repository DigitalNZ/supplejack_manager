# The majority of The Supplejack Manager code is Crown copyright (C) 2014,
# New Zealand Government,
# and is licensed under the GNU General Public License, version 3.
# Some components are third party components that are licensed under
# the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and
# the Department of Internal Affairs.
# http://digitalnz.org/supplejack

class ParserVersionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :find_parser
  before_action :find_version, only: [:show, :update, :new_enrichment, :new_harvest]

  respond_to :html, :json, :js

  def current
    @version = @parser.current_version(params[:environment])
    respond_with @version, serializer: ParserVersionSerializer
  end

  def show
    @harvest_job = HarvestJob.build(parser_id: @parser.id, version_id: @version.id)
    @enrichment_job = EnrichmentJob.build(parser_id: @parser.id, version_id: @version.id)
    respond_with @version, serializer: ParserVersionSerializer
  end

  def update
    @version.update_attributes(parser_version_params[:version])
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

  def parser_version_params
    params.permit!
  end
end
