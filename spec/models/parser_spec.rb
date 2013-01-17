require 'spec_helper'

describe Parser do

  let(:parser) { Parser.new("json/europeana.rb", "") }

  context "validations" do
    it "should not be valid with a invalid strategy" do
      parser.strategy = "sitemap"
      parser.should_not be_valid
    end
  end

  describe ".build" do
    it "initializes a new parser" do
      parser = Parser.build(name: "license.rb", strategy: "json", data: "")
      parser.path.should eq "json/license.rb"
      parser.name.should eq "license.rb"
    end
  end

  describe ".find" do
    let(:blob) { mock(:blob).as_null_object }

    before do 
      THE_REPO.stub_chain(:tree, :/) { blob }
    end

    it "finds the file by it's path" do
      THE_REPO.tree.should_receive(:/).with("xml/natlib_pages.rb") { blob }
      Parser.find("xml-natlib_pages.rb")
    end
  end

  describe ".all" do
    let(:tree) { mock(:tree, contents: [mock(:blob, name: "license.rb", data: "")]) }
    let(:empty_tree) { mock(:tree, contents: []) }

    before(:each) do
      THE_REPO.stub_chain(:tree, :/).with("json") { tree }
      THE_REPO.stub_chain(:tree, :/).with("xml") { empty_tree }
      THE_REPO.stub_chain(:tree, :/).with("rss") { empty_tree }
      THE_REPO.stub_chain(:tree, :/).with("oai") { empty_tree }
    end

    it "should return all parsers" do
      parsers = Parser.all
      parsers.size.should eq 1
      parsers.first.should be_a(Parser)
      parsers.first.name.should eq "license.rb"
      parsers.first.persisted?.should be_true
    end
  end

  describe "#initialize" do
    it "sets the strategy from the path" do
      parser.strategy.should eq "json"
    end

    it "initializes a new strategy" do
      Parser.new(nil, nil)
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
end
