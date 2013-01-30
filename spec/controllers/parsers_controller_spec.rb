require 'spec_helper'

describe ParsersController do

  let(:parser) { mock(:parser, id: "1234", to_param: "1234").as_null_object }
  let(:user) { mock_model(User, id: "1234").as_null_object }

  before(:each) do
    controller.stub(:authenticate_user!) { true }
    controller.stub(:current_user) { user }
  end

  describe "GET 'index'" do
    it "finds all the parser configurations" do
      Parser.should_receive(:all) { [parser] }
      get :index
      assigns(:parsers).should eq [parser]
    end
  end

  describe "GET show" do
    it "finds an existing parser " do
      Parser.should_receive(:find).with("1234") { parser }
      get :show, id: "1234"
      assigns(:parser).should eq parser
    end
  end

  describe "GET 'new'" do
    it "initializes a new parser" do
      Parser.should_receive(:new) { parser }
      get :new
      assigns(:parser).should eq parser
    end
  end

  describe "GET 'edit'" do
    let(:job) { mock_model(HarvestJob).as_null_object }

    before(:each) do
      Parser.stub(:find) { parser }
    end

    it "finds an existing parser " do
      Parser.should_receive(:find).with("1234") { parser }
      get :edit, id: "1234"
      assigns(:parser).should eq parser
    end

    it "initializes a harvest_job" do
      HarvestJob.should_receive(:from_parser).with(parser) { job }
      get :edit, id: "1234"
      assigns(:harvest_job).should eq job
    end
  end

  describe "GET 'create'" do
    before do 
      Parser.stub(:new) { parser }
      parser.stub(:save) { true }
    end

    it "initializes a new parser" do
      Parser.should_receive(:new).with({"name" => "Tepapa"}) { parser }
      post :create, parser: {name: "Tepapa"}
    end

    it "saves the parser" do
      parser.should_receive(:save)
      post :create, parser: {name: "Tepapa"}
    end

    context "valid parser" do
      before { parser.stub(:save) { true }}

      it "redirects to edit page" do
        post :create, parser: {name: "Tepapa"}
        response.should redirect_to edit_parser_path("1234")
      end
    end

    context "invalid parser" do
      before { parser.stub(:save) { false }}

      it "renders the edit action" do
        post :create, parser: {name: "Tepapa"}
        response.should render_template(:new)
      end
    end
  end

  describe "GET 'update'" do
    before do 
      Parser.stub(:find) { parser }
      parser.stub(:update_attributes) { true }
    end

    it "finds an existing parser " do
      Parser.should_receive(:find).with("1234") { parser }
      put :update, id: "1234"
      assigns(:parser).should eq parser
    end

    it "updates the parser attributes" do
      parser.should_receive(:update_attributes).with({"name" => "Tepapa"})
      put :update, id: "1234", parser: {name: "Tepapa"}
    end

    context "valid parser" do
      before { parser.stub(:update_attributes) { true }}

      it "redirects to edit page" do
        put :update, id: "1234"
        response.should redirect_to edit_parser_path("1234")
      end
    end

    context "invalid parser" do
      before { parser.stub(:update_attributes) { false }}

      it "renders the edit action" do
        put :update, id: "1234"
        response.should render_template(:edit)
      end
    end
  end

  describe "GET 'destroy'" do
    before do 
      Parser.stub(:find) { parser }
      parser.stub(:destroy) { true }
    end

    it "finds an existing parser " do
      Parser.should_receive(:find).with("1234") { parser }
      delete :destroy, id: "1234"
      assigns(:parser).should eq parser
    end

    it "destroys the parser config" do
      parser.should_receive(:destroy)
      delete :destroy, id: "1234"
    end
  end

end
