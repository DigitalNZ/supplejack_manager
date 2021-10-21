# frozen_string_literal: true

class SuppressCollectionsController < ApplicationController
  authorize_resource class: false

  respond_to :html, :json

  def index
    blacklisted_request_options = { source: { status: :suppressed } }
    @blacklisted_response = Api::Source.index(env, blacklisted_request_options)
    @blacklisted_sources = JSON.parse(@blacklisted_response)

    top_10_request_options = {
      source: { status: :active },
      limit: 10,
      order_by: :status_updated_at
    }
    @top_10_response = Api::Source.index(env, top_10_request_options)
    @top_10_sources = JSON.parse(@top_10_response)
  end

  def update
    begin
      Api::Source.put(env, params[:id], source: { status: params[:status], status_updated_by: current_user.name })
    rescue RestClient::Exception => e
      Rails.logger.error "Exception #{e} when attempting to post to API"
    end

    redirect_to environment_suppress_collections_path(environment: params[:environment])
  end
end
