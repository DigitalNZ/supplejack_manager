# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CollectionRecordsController do
  before(:each) do
    sign_in create(:user, :admin)
  end

  describe 'GET #index' do
    it 'should be successful' do
      expect(RestClient).to receive(:get).with("#{ENV['API_HOST']}/harvester/records/.json", params: { api_key: ENV['HARVESTER_API_KEY'] })
      get :index, params: { environment: 'development' }
      expect(response).to be_successful
    end

    it 'should search for a record' do
      expect(RestClient).to receive(:get).with("#{ENV['API_HOST']}/harvester/records/abc123.json", params: { api_key: ENV['HARVESTER_API_KEY'] })
      get :index, params: { environment: 'development', id: 'abc123' }
    end

    it 'should handle RESTClient errors' do
      allow(RestClient).to receive(:get).and_raise(RestClient::Exception.new)
      get :index, params: { environment: 'development', id: 'abc123' }
    end
  end

  describe 'PUT #update' do
    it 'should make a post to the api to change the status to active for the record' do
      expect(RestClient).to receive(:put).with("#{ENV['API_HOST']}/harvester/records/abc123", { record: { status: 'active' }, api_key: ENV['HARVESTER_API_KEY'] })
      put :update, params: { environment: 'development', id: 'abc123', status: 'active' }
    end

    it 'should redirect to #index' do
      allow(RestClient).to receive(:put)
      put :update, params: { environment: 'development', id: 'abc123', status: 'active', api_key: ENV['HARVESTER_API_KEY'] }
      expect(response).to redirect_to environment_collection_records_path(environment: 'development', id: 'abc123')
    end
  end
end
