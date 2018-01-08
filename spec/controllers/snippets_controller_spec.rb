# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe SnippetsController do
  let(:snippet) { instance_double(Snippet, name: 'Copyright', id: '1234', to_param: '1234').as_null_object }
  let(:user)    { create(:user, :admin) }

  before(:each) do
    sign_in user
  end

  describe 'GET index' do
    it 'should assign all @snippets' do
      expect(Snippet).to receive(:all) { [snippet] }
      get :index
      expect(assigns(:snippets)).to eq [snippet]
    end
  end

  describe "GET 'new'" do
    it 'initializes a new snippet' do
      Snippet.should_receive(:new) { snippet }
      get :new
      assigns(:snippet).should eq snippet
    end
  end

  describe "GET 'edit'" do
    it "finds an existing snippet" do
      Snippet.should_receive(:find).with("1234") { snippet }
      get :edit, id: "1234"
      assigns(:snippet).should eq snippet
    end
  end

  describe "GET 'create'" do
    before do
      Snippet.stub(:new) { snippet }
      snippet.stub(:save) { true }
    end

    it "initializes a new snippet" do
      Snippet.should_receive(:new).with({"name" => "Copyright"}) { snippet }
      post :create, snippet: {name: "Copyright"}
    end

    it "saves the snippet" do
      snippet.should_receive(:save)
      post :create, snippet: {name: "Copyright"}
    end

    context "valid snippet" do
      before { snippet.stub(:save) { true }}

      it "redirects to edit page" do
        post :create, snippet: {name: "Copyright"}
        response.should redirect_to edit_snippet_path("1234")
      end
    end

    context "invalid snippet" do
      before { snippet.stub(:save) { false }}

      it "renders the edit action" do
        post :create, snippet: {name: "Copyright"}
        response.should render_template(:new)
      end
    end
  end

  describe "GET 'update'" do
    before do
      Snippet.stub(:find) { snippet }
      snippet.stub(:update_attributes) { true }
    end

    it "updates the snippet attributes" do
      snippet.should_receive(:update_attributes).with({"name" => "Copyright"})
      put :update, id: "1234", snippet: {name: "Copyright"}
    end

    context "valid snippet" do
      before { snippet.stub(:update_attributes) { true }}

      it "redirects to edit page" do
        put :update, id: '1234', snippet: { name: '' }
        response.should redirect_to edit_snippet_path('1234')
      end
    end

    context "invalid snippet" do
      before { snippet.stub(:update_attributes) { false }}

      it "renders the edit action" do
        put :update, id: "1234", snippet: { name: '' }
        response.should render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the snippet" do
      Snippet.should_receive(:find).with(snippet.id) { snippet }
      snippet.should_receive(:destroy)
      delete :destroy, id: snippet.id
      response.should redirect_to snippets_path
    end
  end

  describe "GET current_version" do
    before do
      Snippet.stub(:find_by_name) { snippet }
    end

    it "should find the current version of the snippet" do
      Snippet.should_receive(:find_by_name).with("Copyright", :staging) { snippet }
      get :current_version, name: "Copyright", environment: :staging, format: :json
      assigns(:snippet).should eq snippet
    end
  end
end
