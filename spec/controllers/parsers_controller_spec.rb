require 'spec_helper'

describe ParsersController do

  let(:parser) { mock(:parser, id: "123", to_param: "json-europeana.rb").as_null_object }

  before(:each) do
    controller.stub(:authenticate_user!) { true }
  end

  describe "GET 'index'" do
    it "finds all the parser configurations" do
      Parser.should_receive(:all) { [parser] }
      get :index
      assigns(:parsers).should eq [parser]
    end
  end

  describe "GET 'new'" do
    it "initializes a new parser" do
      Parser.should_receive(:build) { parser }
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
      Parser.should_receive(:find).with("json-europeana.rb") { parser }
      get :edit, id: "json-europeana.rb"
      assigns(:parser).should eq parser
    end

    it "initializes a harvest_job" do
      HarvestJob.should_receive(:from_parser).with(parser) { job }
      get :edit, id: "json-europeana.rb"
      assigns(:harvest_job).should eq job
    end
  end

  describe "GET 'create'" do
    before do 
      Parser.stub(:build) { parser }
      parser.stub(:save) { true }
    end

    it "initializes a new parser" do
      Parser.should_receive(:build).with({"name" => "tepapa.rb"}) { parser }
      post :create, parser: {name: "tepapa.rb"}
    end

    it "saves the parser" do
      parser.should_receive(:save)
      post :create, parser: {name: "tepapa.rb"}
    end

    context "valid parser" do
      before { parser.stub(:save) { true }}

      it "redirects to edit page" do
        post :create, parser: {name: "tepapa.rb"}
        response.should redirect_to edit_parser_path("json-europeana.rb")
      end
    end

    context "invalid parser" do
      before { parser.stub(:save) { false }}

      it "renders the edit action" do
        post :create, parser: {name: "tepapa.rb"}
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
      Parser.should_receive(:find).with("json-europeana.rb") { parser }
      put :update, id: "json-europeana.rb"
      assigns(:parser).should eq parser
    end

    it "updates the parser attributes" do
      parser.should_receive(:update_attributes).with({"name" => "tepapa.rb"}, nil)
      put :update, id: "json-europeana.rb", parser: {name: "tepapa.rb"}
    end

    context "valid parser" do
      before { parser.stub(:update_attributes) { true }}

      it "redirects to edit page" do
        put :update, id: "json-europeana.rb"
        response.should redirect_to edit_parser_path("json-europeana.rb")
      end
    end

    context "invalid parser" do
      before { parser.stub(:update_attributes) { false }}

      it "renders the edit action" do
        put :update, id: "json-europeana.rb"
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
      Parser.should_receive(:find).with("json-europeana.rb") { parser }
      delete :destroy, id: "json-europeana.rb"
      assigns(:parser).should eq parser
    end

    it "destroys the parser config" do
      parser.should_receive(:destroy)
      delete :destroy, id: "json-europeana.rb"
    end
  end

end
