# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SourceSerializer do
  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
  end

  let(:source) { create(:source) }
  let(:serializer) { described_class.new(source).as_json }

  describe '#attributes' do
    it 'has an id' do
      expect(serializer).to have_key(:id)
    end

    it 'has a source_id' do
      expect(serializer).to have_key(:source_id)
    end
  end
end
