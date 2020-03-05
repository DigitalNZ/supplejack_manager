# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'API Users Page', type: :feature do
  let(:admins) do
    { id: '123123123',
      name: 'John Doe',
      username: 'JohnTheDoe',
      email: 'john@email.com',
      authentication_token: '123',
      role: 'admin',
      daily_requests: '5000',
      monthly_requests: '150000',
      max_requests: '101010101010' }.stringify_keys!
  end

  context 'user signed out' do
    scenario 'is redirected to user sign in page' do
      visit environment_admin_users_path environment: 'test'
      expect(page.current_path).to eq new_user_session_path
    end
  end

  context 'user signed in' do
    let(:user) { create(:user, :admin) }

    before do
      allow_any_instance_of(Admin::User).to receive(:all).and_return([admins])
      allow_any_instance_of(Admin::User).to receive(:find).and_return(admins)

      visit new_user_session_path
      within(:css, 'form[action="/users/sign_in"]') do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
      end

      click_button 'Sign in'
    end

    scenario 'can be access from the home page navigation' do
      visit root_path
      click_link('staging-api-users')

      expect(page.current_path).to eq environment_admin_users_path(environment: 'staging')
    end

    scenario 'can see a list of user details' do
      visit environment_admin_users_path(environment: 'staging')
      expect(page.has_content?(admins['username'])).to be true
      expect(page.has_content?(admins['name'])).to be true
      expect(page.has_content?(admins['authentication_token'])).to be true
      expect(page.has_content?(admins['email'])).to be true
      expect(page.has_content?(admins['role'])).to be true
      expect(page.has_content?(admins['daily_requests'])).to be true
      expect(page.has_content?(admins['monthly_requests'])).to be true
    end

    scenario 'can click to the edit page for the a user' do
      visit environment_admin_users_path(environment: 'staging')
      click_link("edit-user-#{admins['id']}")
      expect(page.current_path).to eq edit_environment_admin_user_path(environment: 'staging', id: admins['id'])
    end
  end
end
