class SuppressCollectionsController < ApplicationController

  respond_to :html, :json

  def index
    response = RestClient.get("#{ENV['API_HOST']}/link_checker/collections") rescue nil
    @blacklist = JSON.parse(response.body)['suppressed_collections'] if response
  end

  def create
    RestClient.put("#{ENV['API_HOST']}/link_checker/collections/#{params[:id]}", { status: 'suppressed' }) rescue nil
    redirect_to suppress_collections_url
  end

  def destroy
    RestClient.put("#{ENV['API_HOST']}/link_checker/collections/#{params[:id]}", { status: 'active' }) rescue nil
    redirect_to suppress_collections_url
  end

end
