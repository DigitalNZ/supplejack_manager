# The majority of the Supplejack code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components licensed under the GPL or MIT licenses or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

require "spec_helper"

describe SuppressCollectionsController do

  before(:each) do
    controller.stub(:authenticate_user!) { true }
    controller.stub(:current_user) { user }
  end

  describe "GET 'index'" do
    it "should be successful" do
      get :index, environment: "development"
      response.should be_success
    end

    it "should request the blacklist collection and assign it to response" do
      RestClient.should_receive(:get).with("#{ENV['API_HOST']}/sources", params: { :"source[status]" => "suppressed" } )
      get :index, environment: "development"
    end
  end

  describe "PUT 'update'" do
    it "should update the source in the API to active" do
      RestClient.should_receive(:put).with("#{ENV['API_HOST']}/sources/abc123", source: {status: 'active'})
      put :update, id: 'abc123', environment: "development", status: 'active'
    end

    it "should redirect to suppress collections url" do
      RestClient.stub(:put)
      put :update, id: 'abc123', environment: "development", source: {status: 'suppressed'}
      expect(response).to redirect_to environment_suppress_collections_path(environment: "development")
    end

    it "should handle RestClient errors" do
      RestClient.stub(:put).and_raise(RestClient::Exception.new)
      put :update, id: 'abc123', environment: "development", status: 'suppressed'
    end
  end

end