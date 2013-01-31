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
      parser.load_file
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

  describe "current_version" do
    let(:parser) { FactoryGirl.create(:parser, strategy: "json", name: "Natlib") }

    before(:each) do
      parser.update_attributes(tags: ["production"])
      parser.update_attributes(tags: nil)
    end

    it "returns the most recent version tagged with production" do
      parser.reload
      parser.current_version(:production).should eq parser.versions[1]
    end
  end

  describe "#save_with_version" do
    let(:parser) { FactoryGirl.build(:parser, strategy: "json", name: "Natlib") }

    context "valid parser" do
      before(:each) do
        parser.save_with_version
        @version = parser.versions.first
      end

      it "creates a new parser version" do
        parser.versions.size.should eq 1 
      end

      it "copies the contents" do
        @version.content.should eq parser.content
      end

      it "generates the version number" do
        @version.version.should eq 1
      end
    end

    context "invalid parser" do
      it "doesnt generate a new version when saving fails" do
        parser.name = nil
        parser.save_with_version.should be_false
        parser.versions.should be_empty
      end
    end
  end

  describe "#find_version" do
    let(:parser) { FactoryGirl.create(:parser) }

    it "finds the version" do
      parser.save_with_version
      version = parser.versions.first
      parser.find_version(version.id).should eq version
    end
  end
end
