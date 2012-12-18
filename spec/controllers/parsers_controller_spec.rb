require 'spec_helper'

describe ParsersController do

  let(:parser) { mock(:parser, id: "123", to_param: "123") }

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
    it "finds an existing parser " do
      Parser.should_receive(:find).with("123") { parser }
      get :edit, id: "123"
      assigns(:parser).should eq parser
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
      post :create
    end

    context "valid parser" do
      before { parser.stub(:save) { true }}

      it "redirects to edit page" do
        post :create
        response.should redirect_to edit_parser_path("123")
      end
    end

    context "invalid parser" do
      before { parser.stub(:save) { false }}

      it "renders the edit action" do
        post :create
        response.should render_template(:edit)
      end
    end
  end

  describe "GET 'update'" do
    before do 
      Parser.stub(:find) { parser }
      parser.stub(:update_attributes) { true }
    end

    it "finds an existing parser " do
      Parser.should_receive(:find).with("123") { parser }
      put :update, id: "123"
      assigns(:parser).should eq parser
    end

    it "updates the parser attributes" do
      parser.should_receive(:update_attributes).with({"name" => "tepapa.rb"})
      put :update, id: "123", parser: {name: "tepapa.rb"}
    end

    context "valid parser" do
      before { parser.stub(:update_attributes) { true }}

      it "redirects to edit page" do
        put :update, id: "123"
        response.should redirect_to edit_parser_path("123")
      end
    end

    context "invalid parser" do
      before { parser.stub(:update_attributes) { false }}

      it "renders the edit action" do
        put :update, id: "123"
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
      Parser.should_receive(:find).with("123") { parser }
      delete :destroy, id: "123"
      assigns(:parser).should eq parser
    end

    it "destroys the parser config" do
      parser.should_receive(:destroy)
      delete :destroy, id: "123"
    end
  end

end
