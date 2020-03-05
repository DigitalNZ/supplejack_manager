# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'API Users Page', type: :feature do
  let(:admin) do
    { id: '123123123',
      name: 'John Doe',
      username: 'JohnTheDoe',
      email: 'john@email.com',
      authentication_token: '123',
      role: 'admin',
      daily_requests: '50',
      monthly_requests: '1500',
      max_requests: '5000' }.stringify_keys!
  end

  context 'user signed out' do
    scenario 'is redirected to user sign in page' do
      visit edit_environment_admin_user_path(environment: 'staging', id: admin['id'])
      expect(page.current_path).to eq new_user_session_path
    end
  end

  context 'user signed in' do
    let(:user) { create(:user, :admin) }

    before do
      allow_any_instance_of(Admin::User).to receive(:all).and_return([admin])
      allow_any_instance_of(Admin::User).to receive(:find).and_return(admin)

      visit new_user_session_path
      within(:css, 'form[action="/users/sign_in"]') do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
      end

      click_button 'Sign in'
      visit edit_environment_admin_user_path(environment: 'staging', id: admin['id'])
    end

    scenario 'renders the edit user form' do
      expect(page.current_path).to eq edit_environment_admin_user_path(environment: 'staging', id: admin['id'])

      expect(page.has_css?("form#edit-user-form-#{admin['id']}")).to be true
    end

    scenario 'can click to the edit page for the a user' do
      expect_any_instance_of(Admin::User).to receive(:update).with('max_requests' => '10000', 'id' => admin['id'] ).and_return true

      within(:css, "form#edit-user-form-#{admin['id']}") do
        fill_in 'max_requests', with: '10000'
      end

      click_button 'Save User'

      expect(page.current_path).to eq environment_admin_users_path(environment: 'staging')
    end
  end
end
