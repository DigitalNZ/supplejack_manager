# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Preview do
  let(:preview) { Preview.new }

  @preview = { preview: { id: 1 } }.to_json

  describe '#api_record_json' do
    before { allow(preview).to receive(:api_record) { '{"title":"Json!"}' } }
    it 'returns the json in a pretty format' do
      expect(preview.api_record_json).to eq JSON.pretty_generate('title': 'Json!')
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
      expect(preview).to receive(:pretty_xml_output) { }
      preview.raw_output
    end

    it 'should call pretty_json_output when format is not xml' do
      preview.format = 'json'
      expect(preview).to receive(:pretty_json_output) { }
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

  describe '#append_logs' do
    it 'logs defaults to []' do
      expect(Preview.new.logs).to eq []
    end

    it 'saves the status if non empty' do
      preview = Preview.create(status: nil)
      expect(preview.logs).to eq []
    end

    it 'appends the logs only if the status has changed' do
      preview = Preview.create(status: 'line_1')
      expect(preview.logs).to eq ['line_1']

      preview.update(format: 'another_format', status: 'line_1')
      expect(preview.logs).to eq ['line_1']
    end

    it 'appends the logs in the right order' do
      preview = Preview.create(status: 'line_1')
      preview.update(format: 'another_format', status: 'line_2')
      preview.update(format: 'another_format', status: 'line_3')
      expect(preview.logs).to eq ['line_1', 'line_2', 'line_3']
    end
  end
end
