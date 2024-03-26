# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParserSerializer do
  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
  end

  let(:source) { create(:source) }
  let(:parser) { create(:parser, source_id: source) }
  let(:serialized_parser) { described_class.new(parser).as_json }

  describe '#attributes' do
    it 'has an id' do
      expect(serialized_parser).to have_key(:id)
    end

    it 'has a name' do
      expect(serialized_parser).to have_key(:name)
    end

    it 'has a strategy' do
      expect(serialized_parser).to have_key(:strategy)
    end

    it 'has content' do
      expect(serialized_parser).to have_key(:content)
    end

    it 'has a file_name' do
      expect(serialized_parser).to have_key(:file_name)
    end

    it 'has a source' do
      expect(serialized_parser).to have_key(:source)
    end

    it 'has a data_type' do
      expect(serialized_parser).to have_key(:data_type)
    end

    it 'has allow_full_and_flush' do
      expect(serialized_parser).to have_key(:allow_full_and_flush)
    end
  end
end
