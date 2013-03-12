require "spec_helper"

describe RecordsController do

  before(:each) do
    controller.stub(:authenticate_user!) { true }
  end
  
  let(:parser) { mock(:parser).as_null_object }
  let(:previewer) { mock(:previewer) }
  let(:harvester) { mock(:harvester).as_null_object }

  describe "POST index" do
    before { Parser.stub(:find) { parser } }

    it "finds the parser" do
      Parser.should_receive(:find).with("1234") { parser }
      post :index, parser_id: "1234", parser: {}
    end

    it "initializes a previewer object" do
      Previewer.should_receive(:new).with(parser, "Data", "10", nil, nil) { previewer }
      post :index, parser_id: "1234", parser: {content: "Data"}, index: 10
      assigns(:previewer).should eq previewer
    end

    it "initializes a new previewer in test mode" do
      Previewer.should_receive(:new).with(parser, "Data", "10", "test", nil) { previewer }
      post :index, parser_id: "1234", parser: {content: "Data"}, index: 10, environment: "test"
    end

    it "should preview the records from a existing harvest" do
      Previewer.should_receive(:new).with(parser, "Data", "10", "test", true) { previewer }
      post :index, parser_id: "1234", parser: {content: "Data"}, index: 10, environment: "test", review: true
    end
  end
end