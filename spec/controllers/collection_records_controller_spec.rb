# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe CollectionRecordsController do
  let(:user) { instance_double(User, role: 'admin').as_null_object }

  before(:each) do
    allow(controller).to receive(:authenticate_user!) { true }
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'should be successful' do
      expect(RestClient).to receive(:get).with("#{ENV['API_HOST']}/harvester/records/.json", params: { api_key: ENV['HARVESTER_API_KEY'] })
      get :index, environment: 'development'
      expect(response).to be_success
    end

    it 'should search for a record' do
      expect(RestClient).to receive(:get).with("#{ENV['API_HOST']}/harvester/records/abc123.json", params: { api_key: ENV['HARVESTER_API_KEY'] })
      get :index, environment: 'development', id: 'abc123'
    end

    it 'should handle RESTClient errors' do
      allow(RestClient).to receive(:get).and_raise(RestClient::Exception.new)
      get :index, environment: 'development', id: 'abc123'
    end
  end

  describe 'PUT #update' do
    it 'should make a post to the api to change the status to active for the record' do
      expect(RestClient).to receive(:put).with("#{ENV['API_HOST']}/harvester/records/abc123", {record: { status: 'active' }, api_key: ENV['HARVESTER_API_KEY']})
      put :update, environment: 'development', id: 'abc123', status: 'active'
    end

    it 'should redirect to #index' do
      allow(RestClient).to receive(:put)
      put :update, environment: 'development', id: 'abc123', status: 'active', api_key: ENV['HARVESTER_API_KEY']
      expect(response).to redirect_to environment_collection_records_path(environment: 'development', id: 'abc123')
    end
  end
end
