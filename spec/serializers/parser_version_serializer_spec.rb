# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParserVersionSerializer do
  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
  end

  let(:source)     { create(:source) }
  let(:parser)     { create(:parser, source_id: source) }
  let(:user)       { create(:user, :admin) }
  let(:version)    { create(:version, versionable: parser, user:) }
  let(:serializer) { described_class.new(version).as_json }

  describe '#attributes' do
    it 'has an id' do
      expect(serializer).to have_key(:id)
    end

    it 'has a parser_id' do
      expect(serializer).to have_key(:parser_id)
    end

    it 'has a name' do
      expect(serializer).to have_key(:name)
    end

    it 'has a strategy' do
      expect(serializer).to have_key(:strategy)
    end

    it 'has a content' do
      expect(serializer).to have_key(:content)
    end

    it 'has a message' do
      expect(serializer).to have_key(:message)
    end

    it 'has a version' do
      expect(serializer).to have_key(:version)
    end

    it 'has a file_name' do
      expect(serializer).to have_key(:file_name)
    end

    it 'has a data_type' do
      expect(serializer).to have_key(:data_type)
    end
  end
end
