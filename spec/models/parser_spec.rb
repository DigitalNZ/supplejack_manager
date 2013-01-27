require 'spec_helper'

describe Parser do

  let(:parser) { FactoryGirl.build(:parser) }

  context "validations" do
    it "is valid with valid attributes" do
      parser.should be_valid
    end

    it "should not be valid with a invalid strategy" do
      parser.strategy = "sitemap"
      parser.should_not be_valid
    end

    it "should not be valid without a name" do
      parser.name = nil
      parser.should_not be_valid
    end

    it "should not be valid without a content" do
      parser.content = nil
      parser.should_not be_valid
    end
  end

  context "file paths" do
    let(:parser) { FactoryGirl.build(:parser, name: "Europeana", strategy: "json") }

    describe "#file_name" do
      it "returns a correct file_name" do
        parser.file_name.should eq "europeana.rb"
      end

      it "changes spaces for underscores" do
        parser.name = "Data Govt NZ"
        parser.file_name.should eq "data_govt_nz.rb"
      end
    end

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
    let(:parser) { FactoryGirl.build(:parser, strategy: "xml", name: "Natlib") }

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
    let(:parser) { FactoryGirl.build(:parser, strategy: "json", name: "Natlib") }

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
