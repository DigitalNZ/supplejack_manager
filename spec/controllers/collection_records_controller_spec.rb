# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CollectionRecordsController do
  before(:each) do
    sign_in create(:user, :admin)
  end

  describe 'GET #index' do
    it 'should be successful' do
      expect(Api::Record).to_not receive(:get)
      get :index, params: { environment: 'development' }
      expect(response).to be_successful
    end

    it 'should search for a record' do
      expect(Api::Record).to receive(:get).with('development', 'abc123')
      get :index, params: { environment: 'development', id: 'abc123' }
    end

    it 'should handle RESTClient errors' do
      expect(Api::Record).to receive(:get).with('development', 'abc123').and_raise(RestClient::Exception.new)
      get :index, params: { environment: 'development', id: 'abc123' }
    end
  end

  describe 'PUT #update' do
    it 'should make a post to the api to change the status to active for the record' do
      expect(Api::Record).to receive(:put).with('development', 'abc123', { record: { status: 'active' } })
      put :update, params: { environment: 'development', id: 'abc123', status: 'active' }
    end

    it 'should redirect to #index' do
      expect(Api::Record).to receive(:put)
      put :update, params: { environment: 'development', id: 'abc123', status: 'active', api_key: ENV['HARVESTER_API_KEY'] }
      expect(response).to redirect_to environment_collection_records_path(environment: 'development', id: 'abc123')
    end
  end
end
