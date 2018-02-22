
class CollectionRecordsController < ApplicationController
  authorize_resource class: false

  def index
    @record_id = params[:id]
    @response = RestClient.get("#{fetch_env_vars['API_HOST']}/harvester/records/#{@record_id}.json", { params: { api_key: fetch_env_vars['HARVESTER_API_KEY'] } }) rescue nil
    @record = JSON.parse(@response) rescue nil
  end

  def update
    begin
      RestClient.put("#{fetch_env_vars['API_HOST']}/harvester/records/#{params[:id]}", { record: { status: params[:status] }, api_key: fetch_env_vars['HARVESTER_API_KEY'] })
      flash[:notice] = "Record successfully updated"
    rescue Exception => e
      Rails.logger.error "Exception #{e} when attempting to post to API"
    end

    redirect_to environment_collection_records_path(environment: params[:environment], id: params[:id])
  end
end
