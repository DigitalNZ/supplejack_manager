# The majority of The Supplejack Manager code is Crown copyright (C) 2014,
# New Zealand Government,
# and is licensed under the GNU General Public License, version 3.
# Sme components are third party components that are licensed under
# the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ
# and the Department of Internal Affairs. http://digitalnz.org/supplejack

require 'spec_helper'

describe Preview do
  let(:preview) { Preview.new }

  @preview = { preview: { id: 1 } }.to_json

  describe '#api_record_json' do
    before { allow(preview).to receive(:api_record) { '{"title":"Json!"}' } }
    it 'returns the json in a pretty format' do
      expect(preview.api_record_json).to eq JSON.pretty_generate('title': 'Json!')
    end
  end

  describe '#api_record_output' do
    let(:attributes_json) { JSON.pretty_generate('title': 'Json!') }

    before do
      allow(preview).to receive(:api_record_json) { attributes_json }
    end

    it 'returns highlighted json' do
      output = %q{{\n  <span class=\"key\"><span class=\"delimiter\">&quot;</span><span class=\"content\">title</span><span class=\"delimiter\">&quot;</span></span>: <span class=\"string\"><span class=\"delimiter\">&quot;</span><span class=\"content\">Json!</span><span class=\"delimiter\">&quot;</span></span>\n}}
      expect(preview.api_record_output).to match(output)
    end
  end

  describe 'harvested_attributes_json' do
    before { allow(preview).to receive(:harvested_attributes) { '{"title": "Json!"}' } }

    it 'returns the json in a pretty format' do
      expect(preview.send(:harvested_attributes_json)).to eq JSON.pretty_generate(
        'title': 'Json!'
      )
    end
  end

  describe '#harvested_attributes_output' do
    let(:attributes_json) { JSON.pretty_generate('title': 'Json!') }

    before do
      allow(preview).to receive(:harvested_attributes_json) { attributes_json }
    end

    it 'returns highlighted json' do
      output = %q{{\n  <span class=\"key\"><span class=\"delimiter\">&quot;</span><span class=\"content\">title</span><span class=\"delimiter\">&quot;</span></span>: <span class=\"string\"><span class=\"delimiter\">&quot;</span><span class=\"content\">Json!</span><span class=\"delimiter\">&quot;</span></span>\n}}
      expect(preview.harvested_attributes_output).to match(output)
    end
  end

  describe '#field_errors?' do
    it 'returns false when there are no field_errors' do
      allow(preview).to receive(:field_errors)
      expect(preview.field_errors?).to be nil
    end

    it 'returns true when there are field_errors' do
      allow(preview).to receive(:field_errors) { '{ "title":"Invalid" }' }
      expect(preview.field_errors?).to be true
    end
  end

  describe '#field_errors_output' do
    let(:field_errors_json) { JSON.pretty_generate('title': 'Invalid!') }

    before do
      allow(preview).to receive(:field_errors?) { true }
      allow(preview).to receive(:field_errors_json) { field_errors_json }
    end

    it 'returns highlighted json' do
      output = %q{{\n  <span class=\"key\"><span class=\"delimiter\">&quot;</span><span class=\"content\">title</span><span class=\"delimiter\">&quot;</span></span>: <span class=\"string\"><span class=\"delimiter\">&quot;</span><span class=\"content\">Invalid!</span><span class=\"delimiter\">&quot;</span></span>\n}}
      expect(preview.field_errors_output).to match(output)
    end

    it 'returns nil when there are no field_errors' do
      allow(preview).to receive(:field_errors?) { false }
      expect(preview.field_errors_output).to be nil
    end
  end

  describe '#validation_errors?' do
    it 'returns false when there are no validation_errors' do
      allow(preview).to receive(:validation_errors)
      expect(preview.validation_errors?).to be nil
    end

    it 'returns true when there are validation_errors' do
      allow(preview).to receive(:validation_errors) { '{"title":"Invalid"}' }
      expect(preview.validation_errors?).to be true
    end
  end

  describe '#deletable?' do
    it 'returns true if deletable is true in the preview hash' do
      allow(preview).to receive(:deletable) { true }
      expect(preview.deletable?).to be true
    end

    it 'returns false if deletable is not true' do
      allow(preview).to receive(:deletable) { false }
      expect(preview.deletable?).to be false
    end
  end

  describe '#raw_output' do
    before { allow(preview).to receive(:raw_data) }

    it 'should call pretty_xml_output when format is xml' do
      preview.format = 'xml'
      expect(preview).to receive(:pretty_xml_output) {}
      preview.raw_output
    end

    it 'should call pretty_json_output when format is not xml' do
      preview.format = 'json'
      expect(preview).to receive(:pretty_json_output) {}
      preview.raw_output
    end
  end

  describe '#pretty_xml_output' do
    it 'returns the raw data' do
      allow(preview).to receive(:raw_data) { 'I am raw!' }
      expect(preview.pretty_xml_output).to eq 'I am raw!'
    end
  end

  describe 'pretty_json_output' do
    before { allow(preview).to receive(:raw_data) { '{ "title": "Json!" }' } }

    it 'returns the json in a pretty format' do
      expect(preview.send(:pretty_json_output)).to eq JSON.pretty_generate(
        'title': 'Json!'
      )
    end
  end

  describe '#field_errors_json' do
    it 'returns the json in a pretty format' do
      allow(preview).to receive(:field_errors) { '{"title":"WRONG!"}' }
      expect(preview.field_errors_json).to eq JSON.pretty_generate(
        'title': 'WRONG!'
      )
    end

    it 'returns nil when there are no field_errors' do
      allow(preview).to receive(:field_errors)
      expect(preview.field_errors_json).to be nil
    end
  end
end
# Final newline missing.
