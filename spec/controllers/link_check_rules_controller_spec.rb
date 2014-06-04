# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

require 'spec_helper'

describe LinkCheckRulesController do

  let(:link_check_rule) { mock_model(LinkCheckRule, collection_title: "TAPUHI").as_null_object }
  let(:user) { mock_model(User).as_null_object }

  before(:each) do
    controller.stub(:authenticate_user!) { true }
    controller.stub(:current_user) { user }
  end

  describe "GET 'index'" do
    it "should get all of the collection rules" do
      LinkCheckRule.should_receive(:all) { [link_check_rule] }
      get :index, environment: "development"
      assigns(:link_check_rules).should eq [link_check_rule]
    end

    it "should do a where if link_check_rules is defined" do
      params = {link_check_rule: {collection_title: "TAPUHI"}, environment: "development"}
      LinkCheckRule.should_receive(:where).with(params[:link_check_rule].stringify_keys)
      get :index, params
    end
  end

  describe "GET 'new'" do
    it "creates a new collection rule" do
      LinkCheckRule.should_receive(:new) { link_check_rule }
      get :new, environment: "development"
      assigns(:link_check_rule).should eq link_check_rule
    end
  end

  describe "GET 'edit'" do
    it "finds the link_check_rule" do
      LinkCheckRule.should_receive(:find) { link_check_rule }
      get :edit, id: link_check_rule.id, environment: "development"
      assigns(:link_check_rule).should eq link_check_rule
    end
  end

  describe "POST 'create'" do
    it "should make a new collection rule and assign it" do
      LinkCheckRule.should_receive(:new) { link_check_rule }
      post :create, link_check_rule: { collection_title: "TAPUHI", status_codes: "203,205" }, environment: "development"
      assigns(:link_check_rule) { link_check_rule }
    end

    it "should redirect_to the index page" do
      LinkCheckRule.stub(:new) { link_check_rule }
      post :create, link_check_rule: { collection_title: "TAPUHI", status_codes: "203,205" }, environment: "development"
      response.should redirect_to environment_link_check_rules_path(environment: "development")
    end

    context "link_check_rule not valid" do
      it "should render the new template" do
        LinkCheckRule.stub(:new) { link_check_rule }
        link_check_rule.stub(:save) { false }
        post :create, link_check_rule: { collection_title: "TAPUHI", status_codes: "203,205" }, environment: "development"
        response.should render_template(:new)
      end
    end
  end

  describe "PUT 'update'" do
    it "should find the link_check_rule" do
      LinkCheckRule.should_receive(:find) { link_check_rule }
      put :update, id: link_check_rule.id, link_check_rule: { collection_title: "TAPUHI", status_codes: "203,205" }, environment: "development"
      assigns(:link_check_rule) { link_check_rule }
    end

    it "should redirect_to the index path" do
      LinkCheckRule.stub(:find) { link_check_rule }
      put :update, id: link_check_rule.id, link_check_rule: { collection_title: "TAPUHI", status_codes: "203,205" }, environment: "development"
      response.should redirect_to environment_link_check_rules_path(environment: "development")
    end

    it "updates all the attributes" do
      LinkCheckRule.stub(:find) { link_check_rule }
      link_check_rule.should_receive(:update_attributes).with({"collection_title" => "TAPUHI", "status_codes" => "203,205" })
      put :update, id: link_check_rule.id, link_check_rule: { collection_title: "TAPUHI", status_codes: "203,205" }, environment: "development"
    end

    context "link_check_rule not valid" do
      it "should render the edit template" do
        LinkCheckRule.stub(:find) { link_check_rule }
        link_check_rule.stub(:update_attributes) { false }
        post :update, id: link_check_rule.id, link_check_rule: { collection_title: "TAPUHI", status_codes: "203,205" }, environment: "development"
        response.should render_template(:edit)
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "finds the collection rule and destroys it" do
      LinkCheckRule.should_receive(:find) { link_check_rule }
      delete :destroy, id: link_check_rule.id, environment: "development"
      response.should redirect_to environment_link_check_rules_path(environment: "development")
    end
  end

end

