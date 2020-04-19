# frozen_string_literal: true

require 'rails_helper'

class Program
  include Versioned
end

RSpec.describe Version do
  let(:program) { Program.new }
  let(:version) { build(:version) }

  before do
    version.versionable = program
    version.user = build(:user, email: 'test@test.co.nz')
  end

  describe 'validations' do
    context 'Invalid Version' do
      let(:invalid_version) { build(:version, message: nil) }

      it 'requires a message to be present' do
        expect(invalid_version).to_not be_valid
      end

      it 'includes message in the errors array' do
        invalid_version.valid?
        expect(invalid_version.errors[:message]).to include "can't be blank"
      end
    end

    it 'can be valid' do
      expect(version).to be_valid
    end
  end

  describe '#staging?' do
    context 'has staging tag' do
      before { version.tags = ['staging'] }

      it 'should return true' do
        expect(version.staging?).to be true
      end
    end

    context "doesn't have staging tag" do
      before { version.tags = ['production'] }

      it 'should return false' do
        expect(version.staging?).to be false
      end
    end
  end

  describe '#production?' do
    context 'has production tag' do
      before { version.tags = ['production'] }

      it 'should return true' do
        expect(version.production?).to be true
      end
    end

    context "doesn't have production tag" do
      before { version.tags = ['staging'] }

      it 'should return false' do
        expect(version.production?).to be false
      end
    end
  end

  describe '#post_changes' do
    context 'tagged as production' do
      it 'should post to changes app' do
        ENV['CHANGESAPP_HOST'] = 'http://test.host'
        version.tags = ['production']
        expect(RestClient::Request).to receive(:execute).with(anything())
        version.post_changes
      end
    end

    context 'untagged as production' do
      it 'should not post to changes app' do
        version.tags = ['staging']
        expect(RestClient::Request).not_to receive(:execute).with(anything())
        version.post_changes
      end
    end
  end

  describe '#changes_payload' do
    it 'should include component with a value of DNZ Harvester - Program' do
      expect(version.changes_payload).to include(component: 'DNZ Harvester - Program')
    end

    it 'should include description with a value of Test program: New version' do
      program.name = 'Test program'
      version.message = 'New version'

      expect(version.changes_payload).to include(description: 'Test program: New version')
    end

    it 'should include the email of the user that saved the version' do
      expect(version.changes_payload).to include(email: 'test@test.co.nz')
    end

    it 'should include the current time' do
      expect(version.changes_payload[:time]).not_to be_nil
    end

    it 'should include the current Rails environment' do
      expect(version.changes_payload).to include(environment: 'test')
    end

    it 'should include the current version number' do
      version.version = 2
      expect(version.changes_payload).to include(revision: 2)
    end
  end
end
