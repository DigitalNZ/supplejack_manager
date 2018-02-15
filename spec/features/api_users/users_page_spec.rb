# frozen_string_literal: true
require 'rails_helper'

feature 'API Users Page', type: :feature do

  context 'user signed out' do
    scenario 'is redirected to user sign in page' do
      visit environment_admin_users_path environment: 'test'
      expect(page.current_path).to eq new_user_session_path
    end
  end
  # scenario 'can be access from the home page navigation' do
    # before do
    #   visit new_user_session_path
    #    fill_in 'user[login]', with: user.username
    #     fill_in 'user[password]', with: user.password
    #     click_button 'Sign in'
    # end
  #   visit root_path
  #   click_link('test-api-users')
  #   expect(page.current_path).to eq environment_admin_users_path
  # end
end
