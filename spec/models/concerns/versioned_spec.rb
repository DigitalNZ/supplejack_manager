# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Versioned do
  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
  end

  let(:source) { create(:source) }
  let(:parser) { create(:parser, source_id: source) }

  describe '#last_edited_by' do
    it 'should return the last edited by' do
      allow(parser).to receive(:versions) { [build(:version, user: build(:user, name: 'bill'))] }
      expect(parser.last_edited_by).to eq 'bill'
    end

    it 'handles parsers with no versions' do
      allow(parser).to receive(:versions) { [] }
      expect(parser.last_edited_by).to be_nil
    end
  end

  describe 'current_version' do
    context 'production environment' do
      it 'returns the most recent version tagged with production' do
        expect(parser.current_version(:production)).to eq parser.versions[1]
      end
    end

    context 'test environment' do
      it 'returns the most recent version regardless of tags' do
        expect(parser.current_version(:test)).to eq parser.versions.last
      end
    end
  end

  describe '#save_with_version' do
    let(:source) { create(:source) }
    let(:user)   { create(:user, :admin) }
    let(:parser) { create(:parser, strategy: 'json', name: 'Natlib', source_id: source, user_id: user) }

    context 'valid parser' do
      before(:each) do
        parser.save
        @version = parser.versions.first
        @version.message = 'Version'
      end

      context 'content has not changed' do
        it 'it should not trigger #save_with_version after save' do
          expect(parser).not_to receive(:save_with_version)
          parser.save
        end
      end

      context 'content has changed' do
        before do
          parser.content = 'New parser content'
        end

        it 'it should #save_with_version after save' do
          expect(parser).to receive(:save_with_version)
          parser.save!
        end
      end

      it 'creates a new parser version' do
        expect(parser.versions.size).to eq 1
      end

      it 'copies the contents' do
        expect(@version.content).to eq parser.content
      end

      it 'generates the version number' do
        expect(@version.version).to eq 1
      end
    end

    context 'invalid parser' do
      it 'doesnt generate a new version when saving fails' do
        parser2 = build(:parser, source: nil)
        expect(parser2.save).to be false
        expect(parser2.versions).to be_empty
      end
    end
  end

  describe '#find_version' do
    it 'finds the version' do
      parser.save
      version = parser.versions.first
      expect(parser.find_version(version.id)).to eq version
    end
  end
end
