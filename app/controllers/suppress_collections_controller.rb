# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

class SuppressCollectionsController < ApplicationController
  authorize_resource class: false

  respond_to :html, :json

  def index
    @response = RestClient.get("#{fetch_env_vars['API_HOST']}/harvester/sources", { params: {:"source[status]" => "suppressed", api_key: fetch_env_vars['HARVESTER_API_KEY'] } }) rescue nil
    @blacklisted_sources = JSON.parse(@response)["sources"] rescue []
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
