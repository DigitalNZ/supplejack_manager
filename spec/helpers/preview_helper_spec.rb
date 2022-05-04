# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PreviewHelper do
  let(:preview) { Preview.new(raw_data: '') }

  describe '#pretty_raw_data' do
    it 'should call pretty_xml when format is xml' do
      preview.format = 'xml'
      expect_any_instance_of(described_class).to receive(:pretty_xml).with(preview.raw_data) { }
      pretty_raw_data(preview)
    end

    it 'should call pretty_json_output when format is not xml' do
      preview.format = 'json'
      expect_any_instance_of(described_class).to receive(:pretty_json).with(preview.raw_data) { }
      pretty_raw_data(preview)
    end
  end

  describe '#pretty_xml' do
    it 'returns the raw data' do
      expect(pretty_xml('I am raw!')).to eq 'I am raw!'
    end
  end

  describe 'pretty_json' do
    it 'returns the json in a pretty format' do
      expect(pretty_json('{ "title": "Json!" }')).to eq JSON.pretty_generate(
        'title': 'Json!'
      )
    end
  end
end
