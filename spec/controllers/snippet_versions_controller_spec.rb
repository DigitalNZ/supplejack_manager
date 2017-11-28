# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe SnippetVersionsController do
  let(:user)    { instance_double(User, id: '3').as_null_object }
  let(:snippet) { instance_double(Snippet, id: '1').as_null_object }
  let(:version) { instance_double(Version, id: '2').as_null_object }

  before(:each) do
    allow(controller).to receive(:authenticate_user!) { true }
    allow(controller).to receive(:current_user) { user }
    allow(Snippet).to receive(:find).with(anything) { snippet }
    allow(snippet).to receive(:find_version) { version }
  end

  describe 'GET current' do
    it 'gets the current version of the snippet' do
      expect(snippet).to receive(:current_version).with('staging') { version }
      get :current, snippet_id: 1, environment: 'staging', format: 'json'
      expect(assigns(:version)).to eq version
    end
  end

  describe "GET show" do
    it "finds the snippet" do
      expect(Snippet).to receive(:find).with("1") { snippet }
      get :show, snippet_id: 1, id: 1
      expect(assigns(:snippet)).to eq snippet
    end

    it "finds the version of the snippet" do
      expect(snippet).to receive(:find_version).with("1") { version }
      get :show, snippet_id: 1, id: 1
      expect(assigns(:version)).to eq version
    end
  end

  describe "PUT update" do
    it "updates the version" do
      expect(version).to receive(:update_attributes).with({"version"=>{"tags"=>["staging"]}, "id"=>"1", "snippet_id"=>"1", "controller"=>"snippet_versions", "action"=>"update"})
      put :update, id: 1, snippet_id: 1, version: { tags: ["staging"] }
    end

    it "posts a message to the changes app" do
      expect(version).to receive(:post_changes)
      put :update, id: 1, snippet_id: 1, version: { tags: ["staging"] }
    end

    it "redirects to the version path" do
      put :update, id: 1, snippet_id: 1, version: { tags: ["staging"] }
      expect(response).to redirect_to snippet_snippet_version_path(snippet, version)
    end
  end

end
