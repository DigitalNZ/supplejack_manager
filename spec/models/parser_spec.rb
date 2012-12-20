require 'spec_helper'

describe Parser do

  let(:blob) { mock(:blob, name: "europeana.rb", data: "") }
  let(:parser) { Parser.new(blob, "json") }

  context "validations" do
    before(:each) do
      parser.name = "valid_name.rb"
      parser.strategy = "json"
      parser.data = "class Europeana < HarvesterCore::Json::Base; end"
    end

    it "should not be valid with a invalid name" do
      parser.name = "weird name"
      parser.should_not be_valid
    end

    it "should not be valid when it starts with a number" do
      parser.name = "1tapuhi.rb"
      parser.should_not be_valid
    end

    it "should be valid with a valid name" do
      parser.name = "nzmuseums_oai.rb"
      parser.should be_valid
    end

    it "should not be valid with a invalid strategy" do
      parser.strategy = "sitemap"
      parser.should_not be_valid
    end
  end

  describe ".build" do
    it "initializes a empty parser" do
      Parser.build.should be_a Parser
    end

    it "initializes with name, strategy and data" do
      parser = Parser.build(data: "data", strategy: "strategy", name: "name")
      parser.data.should eq "data"
      parser.strategy.should eq "strategy"
      parser.name.should eq "name"
    end
  end

  describe ".find" do
    let(:tree) { mock(:tree) }
    let(:blob) { mock(:blob).as_null_object }

    before do 
      THE_REPO.stub(:tree) { tree }
      tree.stub(:/) { blob }
    end

    it "finds the file by it's path" do
      THE_REPO.tree.should_receive(:/).with("xml/natlib_pages.rb") { blob }
      Parser.find("xml-natlib_pages.rb")
    end

    it "initializes a new parser" do
      Parser.find("xml-natlib_pages.rb").should be_a Parser
    end

    it "initializes a parser with blob and strategy" do
      Parser.should_receive(:new).with(blob, "xml")
      Parser.find("xml-natlib_pages.rb")
    end
  end

  describe ".all" do
    let(:ds_store) { mock(:blob, name: ".DS_STORE") }
    let(:europeana) { mock(:blob, name: "europeana.rb") }
    let(:json) { mock(:tree, name: "json", contents: [europeana]) }

    before do
      THE_REPO.stub(:tree) { mock(:tree, contents: [ds_store, json]) }
    end

    it "returns all the parsers" do
      Parser.should_receive(:new).with(europeana, "json")
      Parser.all
    end
  end

  context "file paths" do
    describe "path" do
      it "returns the file path relative to the repository root dir" do
        parser.path.should eq "json/europeana.rb"
      end
    end

    describe "fullpath" do
      it "returns the full file path" do
        parser.fullpath.should eq "spec/fixtures/test_repo/json/europeana.rb"
      end
    end
  end

  describe "#save" do
    it "commits with the new parser contents" do
      parser.stub(:data) { "class Tv3" }
      parser.stub(:path) { "json/europeana.rb" }
      THE_REPO.should_receive(:add).with("json/europeana.rb", "class Tv3")
      THE_REPO.should_receive(:commit).with("New config", nil)
      parser.save("New config")
    end

    it "returns false when invalid" do
      parser.name = nil
      parser.save.should be_false
    end
  end

  describe "#update_attributes" do
    let(:user) { mock(:user) }

    it "updates the data" do
      parser.should_receive("data=").with("new data")
      parser.should_receive(:save)
      parser.update_attributes({data: "new data"}, nil)
    end

    it "adds a message to the commit" do
      parser.should_receive(:save).with("Testing", nil)
      parser.update_attributes({data: "new data", message: "Testing"}, nil)
    end

    it "sends the commit author" do
      parser.should_receive(:save).with("Testing", user)
      parser.update_attributes({data: "new data", message: "Testing"}, user)
    end
  end
end
