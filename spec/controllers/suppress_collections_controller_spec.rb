require "spec_helper"

describe SuppressCollectionsController do

  before(:each) do
    controller.stub(:authenticate_user!) { true }
    controller.stub(:current_user) { user }
  end

  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should request the blacklist collection" do
      RestClient.should_receive(:get).with("#{ENV['API_HOST']}/link_checker/collections")
      get :index
    end

    it "should assign the blackist to list of suppressed collections" do
      RestClient.stub(:get) { double(:response, body: '{"suppressed_collections":["TAPUHI", "TV3"]}') }
      get :index
      assigns(:blacklist).should eq ["TAPUHI", "TV3"]
    end
  end

  describe "POST 'create'" do
    it "should add the collection to the suppressed collection in the API" do
      RestClient.should_receive(:put).with("#{ENV['API_HOST']}/link_checker/collection", { collection: 'TAPUHI', status: 'suppressed'})
      post :create, id: 'TAPUHI'
    end

    it "should redirect to suppress collections url" do
      RestClient.stub(:put)
      post :create, id: 'TAPUHI'
      expect(response).to redirect_to suppress_collections_url
    end

    it "should handle RestClient errors" do
      RestClient.stub(:put).and_raise(RestClient::Exception.new)
      post :create, id: 'TAPUHI'
    end
  end

  describe "DELETE 'destroy'" do
    it "removes the collection from suppressed collections" do
      RestClient.should_receive(:put).with("#{ENV['API_HOST']}/link_checker/collection", { collection: 'TAPUHI', status: 'active'})
      delete :destroy, id: "TAPUHI"
    end

    it "should redirect to suppress collections url" do
      RestClient.stub(:put)
      post :destroy, id: 'TAPUHI'
      expect(response).to redirect_to suppress_collections_url
    end

    it "should handle RestClient errors" do
      RestClient.stub(:put).and_raise(RestClient::Exception.new)
      post :destroy, id: 'TAPUHI'
    end
  end
end