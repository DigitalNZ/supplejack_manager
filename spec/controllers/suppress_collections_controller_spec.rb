# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SuppressCollectionsController do
  let(:user) { create(:user, :admin) }

  before(:each) do
    sign_in user
  end

  describe "GET 'index'" do
    it 'should call the harvest sources end point to retrieve last 10 updated sources and suppressed' do
      expect(RestClient).to receive(:get).with("#{ENV['API_HOST']}/harvester/sources", params: { "source[status]": 'suppressed', api_key: ENV['HARVESTER_API_KEY'] }) { '{}' }
      expect(RestClient).to receive(:get).with("#{ENV['API_HOST']}/harvester/sources", params: { "source[status]": 'active', limit: 10, order_by: 'status_updated_at', api_key: ENV['HARVESTER_API_KEY'] }) { '{}' }
      get :index, params: { environment: 'development' }
      expect(response).to be_successful
    end
  end

  describe "PUT 'update'" do
    it 'should update the source in the API to active and set status_updated_by' do
      expect(RestClient).to receive(:put).with("#{ENV['API_HOST']}/harvester/sources/abc123", source: { status: 'active', status_updated_by: 'John Doe' }, api_key: ENV['HARVESTER_API_KEY'])
      put :update, params: { id: 'abc123', environment: 'development', status: 'active' }
    end

    it 'should redirect to suppress collections url' do
      allow(RestClient).to receive(:put)
      put :update, params: { id: 'abc123', environment: 'development', source: { status: 'suppressed' }, api_key: ENV['HARVESTER_API_KEY'] }
      expect(response).to redirect_to environment_suppress_collections_path(environment: 'development')
    end

    it 'should handle RestClient errors' do
      allow(RestClient).to receive(:put).and_raise(RestClient::Exception.new)
      put :update, params: { id: 'abc123', environment: 'development', status: 'suppressed', api_key: ENV['HARVESTER_API_KEY'] }
    end
  end
end
