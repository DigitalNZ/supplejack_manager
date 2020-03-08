
class SourcesController < ApplicationController
  load_and_authorize_resource
  skip_before_action :verify_authenticity_token

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
      @partners = Partner.asc(:name)
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
    url = APPLICATION_ENVIRONMENT_VARIABLES[params['env']]['API_HOST']
    RestClient.get("#{url}/harvester/sources/#{@source.id}/reindex", { params: { date: params[:date], api_key: fetch_env_vars['HARVESTER_API_KEY'] } })
  end

  def source_params
    params.require(:source).permit(:source_id, :partner_id, partner_attributes: :name)
  end
end
