# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'User sign out', type: :feature do
  let(:login_page) { LoginPage.new }
  let(:user) { create(:user) }

  before do
    login_page.load

    within login_page.login_form do
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Sign in'
    end

    within login_page.navigation do
      click_link "Hi, #{user.name}"
      click_link 'Logout'
    end
  end

  scenario 'Successfully sign out' do
    expect(login_page.flash_error).to have_content('You need to sign in or sign up before continuing.')
  end

  scenario 'Redirected to login page' do
    expect(page.current_path).to eq login_page.current_path
  end
end
