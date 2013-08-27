class SuppressCollectionsController < ApplicationController

  respond_to :html, :json

  def index
    response = RestClient.get("#{fetch_env_vars['API_HOST']}/link_checker/collections") rescue nil
    @blacklist = JSON.parse(response.body)['suppressed_collections'] if response
  end

  def create
    begin
      RestClient.put("#{fetch_env_vars['API_HOST']}/link_checker/collection", { collection: params[:id], status: 'suppressed' })
    rescue RestClient::Exception => e
      Rails.logger.error "Exception #{e} when attempting to post to API"
    end

    redirect_to environment_suppress_collections_path(environment: params[:environment])
  end

  def destroy
    begin
      RestClient.put("#{fetch_env_vars['API_HOST']}/link_checker/collection", { collection: params[:id], status: 'active' })
    rescue RestClient::Exception => e
      Rails.logger.error "Exception #{e} when attempting to post to API"
    end

    redirect_to environment_suppress_collections_path(environment: params[:environment])
  end

end
