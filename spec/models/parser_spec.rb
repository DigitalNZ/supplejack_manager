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

  describe "#loader" do
    it "should initialize a loader object" do
      ParserLoader.should_receive(:new).with(parser)
      parser.loader
    end
  end

  describe "#load" do
    let!(:loader) { mock(:loader).as_null_object }

    before(:each) do
      parser.stub(:loader) { loader }
    end

    it "should load the parser file" do
      loader.should_receive(:load_parser)
      parser.load
    end
  end

  describe "xml?" do
    let(:parser) { Parser.build({strategy: "xml", name: "natlib.rb"}) }

    it "returns true for Xml strategy" do
      parser.strategy = "xml"
      parser.xml?.should be_true
    end

    it "returns true for Oai strategy" do
      parser.strategy = "oai"
      parser.xml?.should be_true
    end

    it "returns true for Rss strategy" do
      parser.strategy = "rss"
      parser.xml?.should be_true
    end

    it "returns false for Json strategy" do
      parser.strategy = "json"
      parser.xml?.should be_false
    end
  end

  describe "json?" do
    let(:parser) { Parser.build({strategy: "json", name: "natlib.rb"}) }

    it "returns true for Json strategy" do
      parser.strategy = "json"
      parser.json?.should be_true
    end

    it "returns false for Rss strategy" do
      parser.strategy = "rss"
      parser.json?.should be_false
    end
  end
end
