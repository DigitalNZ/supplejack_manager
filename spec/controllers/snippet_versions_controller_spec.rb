# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

require "spec_helper"

describe SnippetVersionsController do

  let(:user) { mock_model(User, id: "3").as_null_object }
  let(:snippet) { mock_model(Snippet, id: "1").as_null_object }
  let(:version) { mock_model(Version, id: "2").as_null_object }

  before(:each) do
    controller.stub(:authenticate_user!) { true }
    controller.stub(:current_user) { user }
    Snippet.stub(:find).with(anything) { snippet }
    snippet.stub(:find_version) { version }
  end

  describe "GET current" do
    it "gets the current version of the snippet" do
      snippet.should_receive(:current_version).with("staging") { version }
      get :current, snippet_id: 1, environment: "staging", format: "json"
      assigns(:version).should eq version
    end
  end

  describe "GET show" do
    it "finds the snippet" do
      Snippet.should_receive(:find).with("1") { snippet }
      get :show, snippet_id: 1, id: 1
      assigns(:snippet).should eq snippet
    end

    it "finds the version of the snippet" do
      snippet.should_receive(:find_version).with("1") { version }
      get :show, snippet_id: 1, id: 1
      assigns(:version).should eq version
    end
  end

  describe "PUT update" do
    it "updates the version" do
      version.should_receive(:update_attributes).with("tags" => ["staging"])
      put :update, id: 1, snippet_id: 1, version: { tags: ["staging"] }
    end

    it "posts a message to the changes app" do
      version.should_receive(:post_changes)
      put :update, id: 1, snippet_id: 1, version: { tags: ["staging"] }
    end

    it "redirects to the version path" do
      put :update, id: 1, snippet_id: 1, version: { tags: ["staging"] }
      response.should redirect_to snippet_snippet_version_path(snippet, version)
    end
  end

end
