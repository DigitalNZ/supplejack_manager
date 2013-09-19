class CollectionRecordsController < ApplicationController

  def index
    @record_id = params[:id]

    @response = RestClient.get("#{fetch_env_vars['API_HOST']}/harvester/records/#{@record_id}.json") rescue nil
    @record = JSON.parse(@response) rescue nil
  end

  def update
    begin
      RestClient.put("#{fetch_env_vars['API_HOST']}/harvester/records/#{params[:id]}", { record: { status: params[:status] } })
      flash[:notice] = "Record successfully updated"
    rescue Exception => e
      Rails.logger.error "Exception #{e} when attempting to post to API"
    end

    redirect_to environment_collection_records_path(environment: params[:environment], id: params[:id])
  end

end