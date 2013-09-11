class SuppressCollectionsController < ApplicationController

  respond_to :html, :json

  def index
    @response = RestClient.get("#{fetch_env_vars['API_HOST']}/sources", { params: {:"source[status]" => "suppressed"}}) rescue nil
    @blacklisted_sources = JSON.parse(@response)["sources"] rescue []
  end

  def update
    begin
      RestClient.put("#{fetch_env_vars['API_HOST']}/sources/#{params[:id]}", { source: { status: params[:status] }})
    rescue RestClient::Exception => e
      Rails.logger.error "Exception #{e} when attempting to post to API"
    end

    redirect_to environment_suppress_collections_path(environment: params[:environment])
  end

end
