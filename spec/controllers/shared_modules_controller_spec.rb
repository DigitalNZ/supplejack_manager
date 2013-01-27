require "spec_helper"

describe SharedModulesController do
  
  let(:shared_module) { mock_model(SharedModule, name: "Copyright", id: "1234", to_param: "1234").as_null_object }
  let(:user) { mock_model(User, id: "1234").as_null_object }

  before(:each) do
    controller.stub(:authenticate_user!) { true }
    controller.stub(:current_user) { user }
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
      SharedModule.should_receive(:new) { shared_module }
      get :new
      assigns(:shared_module).should eq shared_module
    end
  end

  describe "GET 'edit'" do
    it "finds an existing shared_module" do
      SharedModule.should_receive(:find).with("1234") { shared_module }
      get :edit, id: "1234"
      assigns(:shared_module).should eq shared_module
    end
  end

  describe "GET 'create'" do
    before do 
      SharedModule.stub(:new) { shared_module }
      shared_module.stub(:save) { true }
    end

    it "initializes a new shared_module" do
      SharedModule.should_receive(:new).with({"name" => "Copyright"}) { shared_module }
      post :create, shared_module: {name: "Copyright"}
    end

    it "saves the shared_module" do
      shared_module.should_receive(:save)
      post :create, shared_module: {name: "Copyright"}
    end

    context "valid shared_module" do
      before { shared_module.stub(:save) { true }}

      it "redirects to edit page" do
        post :create, shared_module: {name: "Copyright"}
        response.should redirect_to edit_shared_module_path("1234")
      end
    end

    context "invalid shared_module" do
      before { shared_module.stub(:save) { false }}

      it "renders the edit action" do
        post :create, shared_module: {name: "Copyright"}
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
      SharedModule.should_receive(:find).with("1234") { shared_module }
      put :update, id: "1234"
      assigns(:shared_module).should eq shared_module
    end

    it "updates the shared_module attributes" do
      shared_module.should_receive(:update_attributes).with({"name" => "Copyright"})
      put :update, id: "1234", shared_module: {name: "Copyright"}
    end

    context "valid shared_module" do
      before { shared_module.stub(:update_attributes) { true }}

      it "redirects to edit page" do
        put :update, id: "1234"
        response.should redirect_to edit_shared_module_path("1234")
      end
    end

    context "invalid shared_module" do
      before { shared_module.stub(:update_attributes) { false }}

      it "renders the edit action" do
        put :update, id: "1234"
        response.should render_template(:edit)
      end
    end
  end
end