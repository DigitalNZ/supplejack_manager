# frozen_string_literal: true

# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe Parser::TemplateHelpers do
  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
  end

  describe 'update_contents_parser_class!' do
    let(:parser) { build(:parser) }

    it 'replaces the class name in the content' do
      parser.content = 'class KeteDnz < SupplejackCommon::Oai::Base'
      parser.name =  'Nz On Screen'
      parser.update_contents_parser_class!
      expect(parser.content).to eq 'class NzOnScreen < SupplejackCommon::Oai::Base'
    end

    it 'sets the commit message' do
      parser.content = 'class KeteDnz < SupplejackCommon::Oai::Base'
      parser.name =  'Nz On Screen'
      parser.update_contents_parser_class!
      expect(parser.message).to eq 'Renamed parser class'
    end

    it 'replaces specific class names' do
      parser.content = 'class KeteDnz < SupplejackCommon::Oai::Base'
      parser.name = 'Bfm rss'
      parser.update_contents_parser_class!
      expect(parser.content).to eq 'class BfmRss < SupplejackCommon::Oai::Base'
    end
  end

  describe '#apply_parser_template!' do
    let(:parser) { build(:parser, name: 'Nz On Screen', strategy: 'xml') }

    it 'should initialize the parsers content parser class' do
      parser.content = nil
      parser.apply_parser_template!
      expect(parser.content).to eq "class NzOnScreen < SupplejackCommon::Xml::Base\n\nend"
    end

    it 'should not initialize if parsers content is not nil' do
      parser.content = 'Hello World'
      parser.apply_parser_template!
      expect(parser.content).to eq 'Hello World'
    end

    context 'parser_template present' do
      let(:parser_template) { build(:parser_template, name: 'template', content: 'template content') }

      before { parser.parser_template_name = 'template' }

      it 'should add the parser_templates content into the parsers content' do
        parser.content = nil
        expect(ParserTemplate).to receive(:find_by_name).with('template') { parser_template }
        parser.apply_parser_template!
        expect(parser.content).to eq "class NzOnScreen < SupplejackCommon::Xml::Base\n\n\t#{parser_template.content}\n\nend"
      end
    end
  end
end
