# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Partner do
  before do
    allow(Api::Partner).to receive(:post)
  end

  describe 'validations' do
    it 'is not valid without a name' do
      expect(Partner.new.valid?).to be false
    end

    it 'is not valid unless name is unique' do
      create(:partner, name: 'partner')
      p2 = build(:partner, name: 'partner')
      expect(p2.valid?).to be false
    end
  end

  describe 'after save' do
    it 'syncs with the apis' do
      p = build(:partner)
      expect(p).to receive(:update_apis)
      p.save
    end
  end

  describe '#update_apis' do
    let(:partner) { create(:partner) }

    it 'updates each environments' do
      APPLICATION_ENVS.each do |env|
        expect(Api::Partner).to receive(:post).with(env, anything)
      end

      partner.update_apis
    end
  end
end
