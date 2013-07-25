require 'spec_helper'

describe CollectionRulesController do

  let(:collection_rule) { mock_model(CollectionRules, collection_title: "TAPUHI").as_null_object }
  let(:user) { mock_model(User).as_null_object }

  before(:each) do
    controller.stub(:authenticate_user!) { true }
    controller.stub(:current_user) { user }
  end

  describe "GET 'index'" do
    it "should get all of the collection rules" do
      CollectionRules.should_receive(:all) { [collection_rule] }
      get :index
      assigns(:collection_rules).should eq [collection_rule]
    end

    it "should do a where if collection_rules is defined" do
      params = {collection_rules: {collection_title: "TAPUHI"}}
      CollectionRules.should_receive(:where).with(params[:collection_rules].stringify_keys)
      get :index, params
    end
  end

  describe "GET 'show'" do
    it "should get the collection rule" do
      CollectionRules.should_receive(:find) { collection_rule }
      get :show, id: collection_rule.id
      assigns(:collection_rule).should eq collection_rule
    end
  end

  describe "GET 'new'" do
    it "creates a new collection rule" do
      CollectionRules.should_receive(:new) { collection_rule }
      get :new
      assigns(:collection_rule).should eq collection_rule
    end
  end

  describe "GET 'edit'" do
    it "finds the collection_rule" do
      CollectionRules.should_receive(:find) { collection_rule }
      get :edit, id: collection_rule.id
      assigns(:collection_rule).should eq collection_rule
    end
  end

  describe "POST 'create'" do
    it "should make a new collection rule and assign it" do
      CollectionRules.should_receive(:new) { collection_rule }
      post :create, collection_rule: { collection_title: "TAPUHI", status_codes: "203,205" }
      assigns(:collection_rule) { collection_rule }
    end

    it "should redirect_to the index page" do
      CollectionRules.stub(:new) { collection_rule }
      post :create, collection_rule: { collection_title: "TAPUHI", status_codes: "203,205" }
      response.should redirect_to collection_rules_path
    end

    context "collection_rule not valid" do
      it "should render the new template" do
        CollectionRules.stub(:new) { collection_rule }
        collection_rule.stub(:save) { false }
        post :create, collection_rule: { collection_title: "TAPUHI", status_codes: "203,205" }
        response.should render_template(:new)
      end
    end
  end

  describe "PUT 'update'" do
    it "should find the collection_rule" do
      CollectionRules.should_receive(:find) { collection_rule }
      put :update, id: collection_rule.id, collection_rule: { collection_title: "TAPUHI", status_codes: "203,205" }
      assigns(:collection_rule) { collection_rule }
    end

    it "should redirect_to the index path" do
      CollectionRules.stub(:find) { collection_rule }
      put :update, id: collection_rule.id, collection_rule: { collection_title: "TAPUHI", status_codes: "203,205" }
      response.should redirect_to collection_rules_path
    end

    it "updates all the attributes" do
      CollectionRules.stub(:find) { collection_rule }
      collection_rule.should_receive(:update_attributes).with({"collection_title" => "TAPUHI", "status_codes" => "203,205" })
      put :update, id: collection_rule.id, collection_rules: { collection_title: "TAPUHI", status_codes: "203,205" }
    end

    context "collection_rule not valid" do
      it "should render the edit template" do
        CollectionRules.stub(:find) { collection_rule }
        collection_rule.stub(:update_attributes) { false }
        post :update, id: collection_rule.id, collection_rules: { collection_title: "TAPUHI", status_codes: "203,205" }
        response.should render_template(:edit)
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "finds the collection rule and destroys it" do
      CollectionRules.should_receive(:find) { collection_rule }
      delete :destroy, id: collection_rule.id
      response.should redirect_to collection_rules_path
    end
  end

end

