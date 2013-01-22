require "spec_helper"

describe RecordsController do

  before(:each) do
    controller.stub(:authenticate_user!) { true }
  end
  
  let(:parser) { mock(:parser).as_null_object }
  let(:previewer) { mock(:previewer) }
  let(:harvester) { mock(:harvester).as_null_object }

  describe "GET index" do
    before { Parser.stub(:find) { parser } }

    it "finds the parser" do
      Parser.should_receive(:find).with("json-europeana.rb") { parser }
      post :index, parser_id: "json-europeana.rb", parser: {}
    end

    it "initializes a previewer object" do
      Previewer.should_receive(:new).with(parser, "Data") { previewer }
      post :index, parser_id: "json-europeana.rb", parser: {data: "Data"}
      assigns(:previewer).should eq previewer
    end
  end

  describe "POST harvest" do
    before do 
      Parser.stub(:find) { parser }
      Harvester.stub(:new) { harvester }
    end

    it "initializes a harvester object" do
      Harvester.should_receive(:new).with(parser, "10") { harvester }
      post :harvest, parser_id: "json-europeana.rb", parser: {data: "Data"}, limit: 10
      assigns(:harvester).should eq harvester
    end

    it "starts the harvest" do
      harvester.should_receive(:start)
      post :harvest, parser_id: "json-europeana.rb", parser: {data: "Data"}, limit: 10
    end
  end
end