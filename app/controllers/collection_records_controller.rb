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


# https://kibana.digitalnz.org/app/discover#/?_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:now-3d,to:now))&_a=(columns:!(),filters:!(('$state':(store:appState),meta:(alias:!n,disabled:!f,index:'logs-*',key:kubernetes.container.name,negate:!f,params:(query:worker-sidekiq),type:phrase),query:(match_phrase:(kubernetes.container.name:worker-sidekiq)))),index:'logs-*',interval:auto,query:(language:kuery,query:'61a3524e3447d500018853b4'),sort:!(!('@timestamp',desc)))

# fix 31827793