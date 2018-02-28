
require 'rails_helper'

describe SnippetVersionsController do
  let(:user)    { create(:user) }
  let(:snippet) { create(:snippet) }
  let(:version) { create(:version, versionable: snippet, user: user) }

  before(:each) do
    sign_in user
    allow(Snippet).to receive(:find).with(anything) { snippet }
    allow(snippet).to receive(:find_version) { version }
  end

  describe 'GET current' do
    it 'gets the current version of the snippet' do
      expect(snippet).to receive(:current_version).with('staging') { version }
      get :current, params: { snippet_id: 1, environment: 'staging', format: 'json' }
      expect(assigns(:version)).to eq version
    end
  end

  describe "GET show" do
    it "finds the snippet" do
      expect(Snippet).to receive(:find).with("1") { snippet }
      get :show, params: { snippet_id: 1, id: 1 }
      expect(assigns(:snippet)).to eq snippet
    end

    it "finds the version of the snippet" do
      expect(snippet).to receive(:find_version).with("1") { version }
      get :show, params: { snippet_id: 1, id: 1 }
      expect(assigns(:version)).to eq version
    end
  end

  describe "PUT update" do
    it 'updates the version' do
      expect(version).to receive(:update_attributes).with({'tags'=>['staging']})
      put :update, params: { id: 1, snippet_id: 1, version: { tags: ['staging'] } }
    end

    it "posts a message to the changes app" do
      expect(version).to receive(:post_changes)
      put :update, params: { id: 1, snippet_id: 1, version: { tags: ["staging"] } }
    end

    it "redirects to the version path" do
      put :update, params: { id: 1, snippet_id: 1, version: { tags: ["staging"] } }
      expect(response).to redirect_to snippet_snippet_version_path(snippet, version)
    end
  end
end
