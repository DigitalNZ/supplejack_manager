require "spec_helper"

describe SnippetsController do
  
  let(:snippet) { mock_model(Snippet, name: "Copyright", id: "1234", to_param: "1234").as_null_object }
  let(:user) { mock_model(User, id: "1234").as_null_object }

  before(:each) do
    controller.stub(:authenticate_user!) { true }
    controller.stub(:current_user) { user }
  end

  describe "GET index" do
    it "should assign all @snippets" do
      Snippet.should_receive(:all) { [snippet] }
      get :index
      assigns(:snippets).should eq [snippet]
    end
  end

  describe "GET 'new'" do
    it "initializes a new snippet" do
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

    it "finds an existing snippet " do
      Snippet.should_receive(:find).with("1234") { snippet }
      put :update, id: "1234"
      assigns(:snippet).should eq snippet
    end

    it "updates the snippet attributes" do
      snippet.should_receive(:update_attributes).with({"name" => "Copyright"})
      put :update, id: "1234", snippet: {name: "Copyright"}
    end

    context "valid snippet" do
      before { snippet.stub(:update_attributes) { true }}

      it "redirects to edit page" do
        put :update, id: "1234"
        response.should redirect_to edit_snippet_path("1234")
      end
    end

    context "invalid snippet" do
      before { snippet.stub(:update_attributes) { false }}

      it "renders the edit action" do
        put :update, id: "1234"
        response.should render_template(:edit)
      end
    end
  end

  describe "GET search" do
    before do 
      Snippet.stub(:find_by_name) { snippet }
    end

    it "should find the snippet by name" do
      Snippet.should_receive(:find_by_name).with("Copyright") { snippet }
      get :search, name: "Copyright", format: :js
      assigns(:snippet).should eq snippet
    end
  end
end