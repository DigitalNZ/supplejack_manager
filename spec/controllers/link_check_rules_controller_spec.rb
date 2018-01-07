# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe LinkCheckRulesController do
  # let(:link_check_rule) { instance_double(LinkCheckRule).as_null_object }
  let(:link_check_rule) { build(:link_check_rule) }
  let(:user)            { create(:user, :admin) }
  let(:partner)         { build(:partner) }

  before(:each) do
    sign_in user
  end

  describe "GET 'index'" do
    it 'should get all of the collection rules' do
      expect(LinkCheckRule).to receive(:all) { [link_check_rule] }
      get :index, environment: 'development'
      expect(assigns(:link_check_rules)).to eq [link_check_rule]
    end

    it 'should do a where if link_check_rules is defined' do
      params = { link_check_rule: {collection_title: 'collection_title' }, environment: 'development' }
      expect(LinkCheckRule).to receive(:where).with(params[:link_check_rule].stringify_keys)
      get :index, params
    end
  end

  describe "GET 'new'" do
    it 'creates a new collection rule' do
      get :new, environment: 'development'
      expect(assigns(:link_check_rule)).to be_a_new(LinkCheckRule)
    end
  end

  describe "GET 'edit'" do
    it 'loads the partners' do
      allow(Partner).to receive_message_chain(:all, :asc) { [partner] }
      expect(LinkCheckRule).to receive(:find) { link_check_rule }
      get :edit, id: 1, environment: 'development'
      expect(assigns(:partners)).to eq [partner]
    end

    it 'finds the link_check_rule' do
      expect(LinkCheckRule).to receive(:find) { link_check_rule }
      get :edit, id: 1, environment: 'development'
      expect(assigns(:link_check_rule)).to eq link_check_rule
    end
  end

  describe "POST 'create'" do
    before do
      stub_request(:post, 'http://localhost:3002/link_check_rules.json').with(body: "{\"collection_title\":\"collection_title\",\"status_codes\":\"203,205\"}",
         headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Token token=WORKER_KEY', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).to_return(status: 200, body: "", headers: {})
    end

    it 'should make a new collection rule and assign it' do
      post :create, link_check_rule: { collection_title: 'collection_title', status_codes: '203,205' }, environment: 'development'
      assigns(:link_check_rule) { link_check_rule }
    end

    it 'should redirect_to the index page' do
      post :create, link_check_rule: { collection_title: 'collection_title', status_codes: '203,205' }, environment: 'development'
      expect(response).to redirect_to environment_link_check_rules_path(environment: 'development')
    end

    context 'link_check_rule not valid' do
      it 'should render the new template' do
        expect_any_instance_of(LinkCheckRule).to receive(:save) { false }
        post :create, link_check_rule: { collection_title: 'collection_title', status_codes: '203,205' }, environment: 'development'
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT 'update'" do
    context 'valid attributes' do
      before do
        expect(LinkCheckRule).to receive(:find) { link_check_rule }
        expect_any_instance_of(LinkCheckRule).to receive(:update_attributes) { true }
      end

      it 'should find the link_check_rule' do
      put :update, id: 1, link_check_rule: { collection_title: 'collection_title', status_codes: '203,205' }, environment: 'development'
        assigns(:link_check_rule) { link_check_rule }
      end

      it 'should redirect_to the index path' do
        put :update, id: 1, link_check_rule: { collection_title: 'collection_title', status_codes: "203,205" }, environment: "development"
        expect(response).to redirect_to environment_link_check_rules_path(environment: "development")
      end

      it "updates all the attributes" do
        expect(link_check_rule).to receive(:update_attributes).with({"collection_title" => "collection_title", "status_codes" => "203,205" })
        put :update, id: 1, link_check_rule: { collection_title: "collection_title", status_codes: "203,205" }, environment: "development"
      end
    end

    context "link_check_rule not valid" do
      it "should render the edit template" do
        expect(LinkCheckRule).to receive(:find) { link_check_rule }
        expect_any_instance_of(LinkCheckRule).to receive(:update_attributes) { false }
        post :update, id: 1, link_check_rule: { collection_title: "collection_title", status_codes: "203,205" }, environment: "development"
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE 'destroy'" do
    it 'finds the collection rule and destroys it' do
      expect(LinkCheckRule).to receive(:find) { link_check_rule }
      expect_any_instance_of(LinkCheckRule).to receive(:destroy) { true }
      delete :destroy, id: 1, environment: 'development'
      expect(response).to redirect_to environment_link_check_rules_path(environment: 'development')
    end
  end
end
