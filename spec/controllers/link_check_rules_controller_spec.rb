# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe LinkCheckRulesController do
  let(:link_check_rule) { instance_double(LinkCheckRule).as_null_object }
  let(:user)            { instance_double(User).as_null_object }
  let(:admin_user)      { instance_double(User, role: 'admin').as_null_object }
  let(:partner)         { FactoryBot.build(:partner) }

  before(:each) do
    allow(controller).to receive(:authenticate_user!) { true }
    allow(controller).to receive(:current_user) { user }
  end

  describe "GET 'index'" do
    it 'should get all of the collection rules' do
      expect(LinkCheckRule).to receive(:all) { [link_check_rule] }
      get :index, environment: 'development'
      expect(assigns(:link_check_rules)).to eq [link_check_rule]
    end

    it 'should do a where if link_check_rules is defined' do
      params = {link_check_rule: {collection_title: 'collection_title' }, environment: 'development' }
      expect(LinkCheckRule).to receive(:where).with(params[:link_check_rule].stringify_keys)
      get :index, params
    end
  end

  describe "GET 'new'" do
    it "creates a new collection rule" do
      expect(LinkCheckRule).to receive(:new) { link_check_rule }
      get :new, environment: 'development'
      expect(assigns(:link_check_rule)).to eq link_check_rule
    end
  end

  describe "GET 'edit'" do
    it 'loads the partners' do
      expect(user).to receive(:admin?).and_return(true)
      allow(Partner).to receive_message_chain(:all, :asc) { [partner] }
      expect(LinkCheckRule).to receive(:find) { link_check_rule }
      get :edit, id: link_check_rule.id, environment: 'development'
      expect(assigns(:partners)).to eq [partner]
    end

    it 'finds the link_check_rule' do
      expect(LinkCheckRule).to receive(:find) { link_check_rule }
      get :edit, id: link_check_rule.id, environment: 'development'
      expect(assigns(:link_check_rule)).to eq link_check_rule
    end
  end

  describe "POST 'create'" do
    it 'should make a new collection rule and assign it' do
      expect(LinkCheckRule).to receive(:new) { link_check_rule }
      post :create, link_check_rule: { collection_title: 'collection_title', status_codes: '203,205' }, environment: "development"
      assigns(:link_check_rule) { link_check_rule }
    end

    it "should redirect_to the index page" do
      allow(LinkCheckRule).to receive(:new) { link_check_rule }
      post :create, link_check_rule: { collection_title: 'collection_title', status_codes: '203,205' }, environment: "development"
      expect(response).to redirect_to environment_link_check_rules_path(environment: "development")
    end

    context "link_check_rule not valid" do
      it "should render the new template" do
        allow(LinkCheckRule).to receive(:new) { link_check_rule }
        allow(link_check_rule).to receive(:save) { false }
        post :create, link_check_rule: { collection_title: 'collection_title', status_codes: "203,205" }, environment: "development"
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT 'update'" do
    it "should find the link_check_rule" do
      expect(LinkCheckRule).to receive(:find) { link_check_rule }
      put :update, id: link_check_rule.id, link_check_rule: { collection_title: 'collection_title', status_codes: "203,205" }, environment: "development"
      assigns(:link_check_rule) { link_check_rule }
    end

    it "should redirect_to the index path" do
      allow(LinkCheckRule).to receive(:find) { link_check_rule }
      put :update, id: link_check_rule.id, link_check_rule: { collection_title: 'collection_title', status_codes: "203,205" }, environment: "development"
      expect(response).to redirect_to environment_link_check_rules_path(environment: "development")
    end

    it "updates all the attributes" do
      allow(LinkCheckRule).to receive(:find) { link_check_rule }
      expect(link_check_rule).to receive(:update_attributes).with({"collection_title" => "collection_title", "status_codes" => "203,205" })
      put :update, id: link_check_rule.id, link_check_rule: { collection_title: "collection_title", status_codes: "203,205" }, environment: "development"
    end

    context "link_check_rule not valid" do
      it "should render the edit template" do
        allow(LinkCheckRule).to receive(:find) { link_check_rule }
        allow(link_check_rule).to receive(:update_attributes) { false }
        post :update, id: link_check_rule.id, link_check_rule: { collection_title: "collection_title", status_codes: "203,205" }, environment: "development"
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "finds the collection rule and destroys it" do
      expect(LinkCheckRule).to receive(:find) { link_check_rule }
      delete :destroy, id: link_check_rule.id, environment: "development"
      expect(response).to redirect_to environment_link_check_rules_path(environment: "development")
    end
  end

end
