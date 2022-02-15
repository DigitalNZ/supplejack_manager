# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:user) { build(:user, name: 'Federico Gonzalez') }

  describe '.active' do
    let!(:deactive) { create(:user, name: 'Deactivated User', email: 'deactivated@example.com', active: false) }

    it 'should return only active users' do
      user.save!
      expect(User.active.count).to eq 1
    end
  end

  describe 'validations' do
    it 'should be valid' do
      expect(user).to be_valid
    end

    it 'should not be valid with an invalid role' do
      user.role = 'not valid'
      expect(user).not_to be_valid
    end
  end

  describe 'admin?' do
    it 'should return true for an admin' do
      user.role = 'admin'
      expect(user.admin?).to be true
    end

    it 'should return false for a user' do
      user.role = 'developer'
      expect(user.admin?).to be false
    end
  end

  describe '#first_name' do
    it 'returns the first name' do
      expect(user.first_name).to eq 'Federico'
    end

    it 'returns nil when name is not present' do
      user.name = nil
      expect(user.first_name).to be nil
    end
  end

  describe 'active_for_authentication?' do
    context 'active user' do
      it 'should return true' do
        user.active = true
        expect(user.active_for_authentication?).to be true
      end
    end

    context 'in-active user' do
      it 'should return false' do
        user.active = false
        expect(user.active_for_authentication?).to be false
      end
    end
  end

  describe 'run_harvest_partners=' do
    it 'should remove the blank entries' do
      user.run_harvest_partners = (['a', '', 'c'])
      expect(user.run_harvest_partners).to eq ['a', 'c']
    end
  end

  describe 'generate_totp' do
    it 'generate the totp after the user has been created' do
      allow_any_instance_of(User).to receive(:need_two_factor_authentication?).and_return(true)
      user = User.new(name: 'test', password: 'password', password_confirmation: 'password', email: 'test@test.co.nz')
      expect(user.otp_secret_key).to eq nil
      user.save!
      expect(user.otp_secret_key).not_to be_empty
    end
  end
end
