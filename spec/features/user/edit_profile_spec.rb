# frozen_string_literal: true
require 'rails_helper'

feature 'User change its profile', type: :feature, js: true do
  let(:edit_user_page) { EditUserPage.new }
  let(:users_page)     { UsersPage.new }
  let(:user) { create(:user) }
  let(:admin_user) { create(:user, :admin, email: 'admin@test.com') }

  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
  end

  context 'As a normal user' do
    before do
      login_as(user, scope: :user)
      edit_user_page.load(id: user.id)
    end

    scenario 'Updates profile information' do
      new_email = 'update@test.com'
      new_name = 'Test John'
      new_password = 'terces'

      fill_in 'user[name]', with: new_name
      fill_in 'user[email]', with: new_email
      fill_in 'user[password]', with: new_password
      fill_in 'user[password_confirmation]', with: new_password

      click_button 'Update User'

      updated_user = User.find(user.id)
      expect(updated_user.email).to eq new_email
      expect(updated_user.name).to eq new_name

      expect(edit_user_page).to have_flash_success

      logout(:user)

      login_page = LoginPage.new
      login_page.load
      fill_in 'user[email]', with: new_email
      fill_in 'user[password]', with: new_password
      click_button 'Sign in'

      expect(login_page.flash_success).to have_content('Signed in successfully.')
    end
  end

  context 'As an admin user' do
    let!(:partner) { create(:partner) }

    before do
      login_as(admin_user, scope: :user)
      edit_user_page.load(id: admin_user.id)
    end

    scenario 'Updates profile information' do
      check 'user[manage_data_sources]'
      check 'user[manage_parsers]'
      check 'user[manage_harvest_schedules]'
      check 'user[manage_link_check_rules]'

      within edit_user_page.manage_permission_select do
        select partner.name
      end

      within edit_user_page.run_permission_select do
        select partner.name
      end

      click_button 'Update User'

      admin_user.reload

      expect(admin_user.manage_data_sources).to be_truthy
      expect(admin_user.manage_harvest_schedules).to be_truthy
      expect(admin_user.manage_link_check_rules).to be_truthy
      expect(admin_user.manage_parsers).to be_truthy

      expect(admin_user.manage_partners).to eq [partner.id.to_s]
      expect(admin_user.run_harvest_partners).to eq [partner.id.to_s]

      expect(users_page).to have_flash_success
    end
  end
end
