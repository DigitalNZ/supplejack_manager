# frozen_string_literal: true

class CollectionRecordsController < ApplicationController
  authorize_resource class: false

  def index
    @record_id = params[:id]
    if @record_id
      @response = Api::Record.get(env, @record_id) rescue nil
      @record = JSON.parse(@response) rescue nil
    else
      @response = nil
      @record = nil
    end
  end

  def update
    begin
      Api::Record.put(env, params[:id], { record: { status: params[:status] } })
      flash[:notice] = 'Record successfully updated'
    rescue Exception => e
      Rails.logger.error "Exception #{e} when attempting to post to API"
    end

    redirect_to environment_collection_records_path(environment: params[:environment], id: params[:id])
  end
end
