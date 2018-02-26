# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnippetVersionSerializer do
  let(:user)       { create(:user, :admin) }
  let(:snippet)    { create(:snippet) }
  let(:version)    { create(:version, versionable: snippet, user: user) }
  let(:serializer) { described_class.new(version).as_json }

  before(:each) do
    allow(Snippet).to receive(:find).with(anything) { snippet }
    allow(snippet).to receive(:find_version) { version }
  end

  describe '#attributes' do
    it 'has an id' do
      expect(serializer).to have_key(:id)
    end

    it 'has a snippet_id' do
      expect(serializer).to have_key(:snippet_id)
    end

    it 'has a name' do
      expect(serializer).to have_key(:name)
    end

    it 'has content' do
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
  end
end
