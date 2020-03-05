# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'User has forgotten the password', type: :feature do
  let(:forgot_password_page) { ForgotPasswordPage.new }
  let!(:user) { create(:user) }

  before do
    forgot_password_page.load
  end

  context 'Successfully resets the password' do
    before do
      fill_in 'user[email]', with: user.email
      click_button 'Send me reset password instructions'
    end

    scenario 'Displays a success message' do
      expect(forgot_password_page.flash_success).to have_content('You will receive an email with instructions about how to reset your password in a few minutes.')
    end

    scenario 'Redirected to login page' do
      expect(page.current_path).to eq forgot_password_page.current_path
    end
  end

  scenario 'Reset password email is sent to the user' do
    expect(Devise::Mailer).to receive(:reset_password_instructions).and_call_original
    fill_in 'user[email]', with: user.email
    click_button 'Send me reset password instructions'
  end

  scenario 'User gets an error if credentials are invalid' do
    fill_in 'user[email]', with: 'invalid@email.com'
    click_button 'Send me reset password instructions'

    expect(page).to have_content('Email not found')
  end
end
