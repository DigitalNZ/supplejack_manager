require 'spec_helper'

describe Parser do

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
    let(:blob) { mock(:blob, name: "europeana.rb", data: "") }
    let(:parser) { Parser.new(blob, "json") }

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
end
