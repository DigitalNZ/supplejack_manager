require "spec_helper"

describe SharedModulesController do
  
  let(:shared_module) { mock_model(SharedModule, name: "copyright.rb", id: "copyright.rb") }

  before(:each) do
    controller.stub(:authenticate_user!) { true }
  end

  describe "GET index" do
    it "should assign all @shared_modules" do
      SharedModule.should_receive(:all) { [shared_module] }
      get :index
      assigns(:shared_modules).should eq [shared_module]
    end
  end

  describe "GET 'new'" do
    it "initializes a new shared_module" do
      SharedModule.should_receive(:build) { shared_module }
      get :new
      assigns(:shared_module).should eq shared_module
    end
  end

  describe "GET 'edit'" do
    it "finds an existing shared_module" do
      SharedModule.should_receive(:find).with("copyright.rb") { shared_module }
      get :edit, id: "copyright.rb"
      assigns(:shared_module).should eq shared_module
    end
  end

  describe "GET 'create'" do
    before do 
      SharedModule.stub(:build) { shared_module }
      shared_module.stub(:save) { true }
    end

    it "initializes a new shared_module" do
      SharedModule.should_receive(:build).with({"name" => "copyright.rb"}) { shared_module }
      post :create, shared_module: {name: "copyright.rb"}
    end

    it "saves the shared_module" do
      shared_module.should_receive(:save)
      post :create, shared_module: {name: "copyright.rb"}
    end

    context "valid shared_module" do
      before { shared_module.stub(:save) { true }}

      it "redirects to edit page" do
        post :create, shared_module: {name: "copyright.rb"}
        response.should redirect_to edit_shared_module_path("copyright.rb")
      end
    end

    context "invalid shared_module" do
      before { shared_module.stub(:save) { false }}

      it "renders the edit action" do
        post :create, shared_module: {name: "copyright.rb"}
        response.should render_template(:new)
      end
    end
  end

  describe "GET 'update'" do
    before do 
      SharedModule.stub(:find) { shared_module }
      shared_module.stub(:update_attributes) { true }
    end

    it "finds an existing shared_module " do
      SharedModule.should_receive(:find).with("copyright.rb") { shared_module }
      put :update, id: "copyright.rb"
      assigns(:shared_module).should eq shared_module
    end

    it "updates the shared_module attributes" do
      shared_module.should_receive(:update_attributes).with({"name" => "copyright.rb"}, nil)
      put :update, id: "copyright.rb", shared_module: {name: "copyright.rb"}
    end

    context "valid shared_module" do
      before { shared_module.stub(:update_attributes) { true }}

      it "redirects to edit page" do
        put :update, id: "copyright.rb"
        response.should redirect_to edit_shared_module_path("copyright.rb")
      end
    end

    context "invalid shared_module" do
      before { shared_module.stub(:update_attributes) { false }}

      it "renders the edit action" do
        put :update, id: "copyright.rb"
        response.should render_template(:edit)
      end
    end
  end
end