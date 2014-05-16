# The majority of the Supplejack code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components licensed under the GPL or MIT licenses or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

require 'spec_helper'

describe Parser::TemplateHelpers do
  before do
    Partner.any_instance.stub(:update_apis)
    Source.any_instance.stub(:update_apis)
    LinkCheckRule.stub(:create)
  end

  describe "update_contents_parser_class!" do

    let(:parser) { FactoryGirl.create(:parser) }

    it "replaces the class name in the content" do
      parser.content = "class KeteDnz < HarvesterCore::Oai::Base"
      parser.name =  "Nz On Screen"
      parser.update_contents_parser_class!
      parser.content.should eq "class NzOnScreen < HarvesterCore::Oai::Base"
    end

    it "sets the commit message" do
      parser.content = "class KeteDnz < HarvesterCore::Oai::Base"
      parser.name =  "Nz On Screen"
      parser.update_contents_parser_class!
      parser.message.should eq "Renamed parser class"
    end

    it "replaces specific class names" do
      parser.content = "class KeteDnz < HarvesterCore::Oai::Base"
      parser.name = "Bfm rss"
      parser.update_contents_parser_class!
      parser.content.should eq "class BfmRss < HarvesterCore::Oai::Base"
    end
  end

  describe "#apply_parser_template!" do

    let(:parser) { FactoryGirl.build(:parser, name: "Nz On Screen", strategy: "xml")  }

    it "should initialize the parsers content parser class" do
      parser.content = nil
      parser.apply_parser_template!
      parser.content.should eq "class NzOnScreen < HarvesterCore::Xml::Base\n\nend"
    end

    it "should not initialize if parsers content is not nil" do
      parser.content = "Hello World"
      parser.apply_parser_template!
      parser.content.should eq "Hello World"
    end

    context "parser_template present" do

      let(:parser_template) { mock_model(ParserTemplate, name: "template", content: "template content").as_null_object }

      before { parser.parser_template_name = "template" }

      it "should add the parser_templates content into the parsers content" do
        parser.content = nil
        ParserTemplate.should_receive(:find_by_name).with("template") { parser_template }
        parser.apply_parser_template!
        parser.content.should eq "class NzOnScreen < HarvesterCore::Xml::Base\n\n\t#{parser_template.content}\n\nend"
      end
    end
  end
end