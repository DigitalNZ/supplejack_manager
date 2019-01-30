
require 'rails_helper'

describe Preview do
  let(:preview) { Preview.new }

  @preview = { preview: { id: 1 } }.to_json

  describe '#api_record_json' do
    before { allow(preview).to receive(:api_record) { '{"title":"Json!"}' } }
    it 'returns the json in a pretty format' do
      expect(preview.api_record_json).to eq JSON.pretty_generate('title': 'Json!')
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
end
