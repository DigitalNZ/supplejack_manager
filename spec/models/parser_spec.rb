# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

require 'spec_helper'

describe Parser do
  before do
    Partner.any_instance.stub(:update_apis)
    Source.any_instance.stub(:update_apis)
    LinkCheckRule.stub(:create)
  end

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

    it "should not be valid with a duplicated name" do
      parser1 = FactoryGirl.create(:parser, name: 'NZ Museums')
      parser2 = FactoryGirl.build(:parser, name: 'NZ Museums')
      parser2.should_not be_valid
    end
  end

  describe "before:destroy" do
    it "should destroy all HarvestSchedules for the given parser." do
      HarvestSchedule.should_receive(:destroy_all_for_parser).with(parser.id)
      parser.destroy
    end
  end

  describe ".find_by_partners" do
    let!(:partner) { FactoryGirl.create(:partner) }
    let!(:source) { FactoryGirl.create(:source, partner: partner) }
    let!(:parser) { FactoryGirl.create(:parser, source: source) }

    it "should find the Partner" do
      Parser.find_by_partners([partner.id]).should eq [parser]
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

  describe "#enrichment_definitions" do
    let(:parser_class) { mock(:parser_class, enrichment_definitions: {ndha_rights: "Hi"} )}
    let(:loader) { mock(:loader, loaded?: true, parser_class: parser_class).as_null_object }

    before(:each) do
      parser.stub(:loader) { loader }
    end

    it "returns the parser enrichment definitions" do
      loader.parser_class.enrichment_definitions("staging").should eq({ndha_rights: "Hi"})
    end

    it "rescues from a excepction" do
      loader.stub(:parser_class).and_raise(StandardError.new("hi"))
      parser.enrichment_definitions("staging").should eq({})
    end

    it "should not fail when the parser fails to be loaded due to a syntax error" do
      loader.stub(:parser_class).and_raise(SyntaxError.new("broken syntax"))
      parser.enrichment_definitions("staging").should eq({})
    end

    it "returns an empty hash when the parser is unable to load" do
      loader.stub(:loaded?) { false }
      parser.enrichment_definitions("staging").should eq({})
    end
  end

  describe "#modes" do
    it "returns normal and full_and_flush if the parser is not oai" do
      parser.stub(:oai?) {false}
      parser.modes.should eq [['Normal','normal'],['Full And Flush', 'full_and_flush']]
    end

    it "returns normal, full_and_flush and incremental if the parser is oai" do
      parser.stub(:oai?) {true}
      parser.modes.should eq [['Normal','normal'],['Full And Flush','full_and_flush'], ['Incremental','incremental']]
    end
  end
end
