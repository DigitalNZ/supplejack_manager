class SuppressCollectionsController < ApplicationController

  respond_to :html, :json

  def index
    response = RestClient.get("#{ENV['API_HOST']}/link_checker/collections") rescue nil
    @blacklist = JSON.parse(response.body)['suppressed_collections'] if response
  end

  def create
    begin
      name = ERB::Util.url_encode(params[:id])
      RestClient.put("#{ENV['API_HOST']}/link_checker/collections/#{name}", { status: 'suppressed' })
    rescue RestClient::Exception => e
      Rails.logger.error "Exception #{e} when attempting to post to API"
    end

    redirect_to suppress_collections_url
  end

  def destroy
    begin
      name = ERB::Util.url_encode(params[:id])
      RestClient.put("#{ENV['API_HOST']}/link_checker/collections/#{name}", { status: 'active' })
    rescue RestClient::Exception => e
      Rails.logger.error "Exception #{e} when attempting to post to API"
    end

    redirect_to suppress_collections_url
  end

end
