require "spec_helper"

describe RecordsController do

  before(:each) do
    controller.stub(:authenticate_user!) { true }
  end
  
  let(:parser) { mock(:parser) }
  let(:previewer) { mock(:previewer) }

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
end