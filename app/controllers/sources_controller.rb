# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

class SourcesController < ApplicationController
  load_and_authorize_resource
  skip_before_action :verify_authenticity_token

  skip_before_filter :authenticate_user!

  respond_to :html, :json

  def index
    @sources = params[:source].present? ? Source.where(params[:source]) : Source.all
    respond_with @sources
  end

  def show
    respond_with @source
  end

  def new
    @source.partner = Partner.new

    if can? :manage, Partner
      @partners = Partner.asc(:name)
    else
      @partners = Partner.find(current_user.manage_partners)
    end
  end

  def edit
    if can? :manage, Partner
      @partners = Partner.asc(:name)
    else
      @partners = Partner.find(current_user.manage_partners)
    end
  end

  def create
    if @source.save
      redirect_to sources_path, notice: 'Source was successfully created.'
    else
      render :new
    end
  end

  def update
    if @source.update_attributes(source_params)
      redirect_to sources_path, notice: 'Source was successfully updated.'
    else
      render :edit
    end
  end

  def reindex
    url = APPLICATION_ENVIRONMENT_VARIABLES[params[:environment]]['API_HOST']
    RestClient.get("#{url}/harvester/sources/#{@source.id}/reindex", { params: { date: params[:date], api_key: fetch_env_vars['HARVESTER_API_KEY'] } })
  end

  def source_params
    params.require(:source).permit(:name, :source_id, :partner_id, partner_attributes: :name)
  end
end
