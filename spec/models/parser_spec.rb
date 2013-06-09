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
      HarvesterCore::Loader.should_receive(:new).with(parser)
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
      parser.attributes = {tags: ["production"], content: "Hi 1"}
      parser.save_with_version
      parser.attributes = {tags: nil, content: "Hi 2"}
      parser.save_with_version
      parser.reload
    end

    context "production environment" do
      it "returns the most recent version tagged with production" do
        parser.current_version(:production).should eq parser.versions[0]
      end
    end

    context "test environment" do
      it "returns the most recent version regardless of tags" do
        parser.current_version(:test).should eq parser.versions[1]
      end
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

  describe "#enrichment_definitions" do
    let(:parser_class) { mock(:parser_class, enrichment_definitions: {ndha_rights: "Hi"} )}
    let(:loader) { mock(:loader, loaded?: true, parser_class: parser_class).as_null_object }

    before(:each) do
      parser.stub(:loader) { loader }
    end

    it "returns the parser enrichment definitions" do
      parser.enrichment_definitions.should eq({ndha_rights: "Hi"})
    end

    it "rescues from a excepction" do
      loader.stub(:parser_class).and_raise(StandardError.new("hi"))
      parser.enrichment_definitions.should eq({})
    end

    it "should not fail when the parser fails to be loaded due to a syntax error" do
      loader.stub(:parser_class).and_raise(SyntaxError.new("broken syntax"))
      parser.enrichment_definitions.should eq({})
    end

    it "returns an empty hash when the parser is unable to load" do
      loader.stub(:loaded?) { false }
      parser.enrichment_definitions.should eq({})
    end
  end
end
