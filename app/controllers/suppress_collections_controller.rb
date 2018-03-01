
class SuppressCollectionsController < ApplicationController
  authorize_resource class: false

  respond_to :html, :json

  def index
    @response = RestClient.get("#{fetch_env_vars['API_HOST']}/harvester/sources", { params: {:"source[status]" => "suppressed", api_key: fetch_env_vars['HARVESTER_API_KEY'] } })
    @blacklisted_sources = JSON.parse(@response)
  end

  def update
    begin
      RestClient.put("#{fetch_env_vars['API_HOST']}/harvester/sources/#{params[:id]}", { source: { status: params[:status] }, api_key: fetch_env_vars['HARVESTER_API_KEY'] })
    rescue RestClient::Exception => e
      Rails.logger.error "Exception #{e} when attempting to post to API"
    end

    redirect_to environment_suppress_collections_path(environment: params[:environment])
  end

end
