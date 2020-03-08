# frozen_string_literal: true

class SuppressCollectionsController < ApplicationController
  authorize_resource class: false

  respond_to :html, :json

  def index
    sources_url = "#{fetch_env_vars['API_HOST']}/harvester/sources"
    blacklisted_request_options = {
      params: {
        'source[status]': 'suppressed',
        api_key: fetch_env_vars['HARVESTER_API_KEY']
      }
    }
    @blacklisted_response = RestClient.get(sources_url, blacklisted_request_options)
    @blacklisted_sources = JSON.parse(@blacklisted_response)

    top_10_request_options = {
      params: {
        'source[status]': 'active',
        limit: 10, order_by: 'status_updated_at',
        api_key: fetch_env_vars['HARVESTER_API_KEY']
      }
    }
    @top_10_response = RestClient.get(sources_url, top_10_request_options)
    @top_10_sources = JSON.parse(@top_10_response)
  end

  def update
    begin
      RestClient.put("#{fetch_env_vars['API_HOST']}/harvester/sources/#{params[:id]}", { source: { status: params[:status], status_updated_by: current_user.name }, api_key: fetch_env_vars['HARVESTER_API_KEY'] })
    rescue RestClient::Exception => e
      Rails.logger.error "Exception #{e} when attempting to post to API"
    end

    redirect_to environment_suppress_collections_path(environment: params[:environment])
  end
end
