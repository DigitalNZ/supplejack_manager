require 'spec_helper'

describe CollectionRecordsController do
  before(:each) do
    controller.stub(:authenticate_user!) { true }
    controller.stub(:current_user) { user }
  end

  describe 'GET #index' do
    it "should be successful" do
      get :index, environment: "development"
      response.should be_success
    end

    it 'should search for a record' do
      RestClient.should_receive(:get).with("#{ENV['API_HOST']}/harvester/records/abc123.json")
      get :index, environment: 'development', id: 'abc123'
    end

    it 'should handle RESTClient errors' do
      RestClient.stub(:get).and_raise(RestClient::Exception.new)
      get :index, environment: 'development', id: 'abc123'
    end
  end

  describe 'PUT #update' do
    before { RestClient.stub(:put) }

    it 'should make a post to the api to change the status to active for the record' do
      RestClient.should_receive(:put).with("#{ENV['API_HOST']}/harvester/records/abc123", {record: { status: 'active' }})
      put :update, environment: 'development', id: 'abc123', status: 'active'
    end

    it 'should redirect to #index' do
      RestClient.stub(:put)
      put :update, environment: 'development', id: 'abc123', status: 'active'
      expect(response).to redirect_to environment_collection_records_path(environment: 'development', id: 'abc123')
    end
  end
end