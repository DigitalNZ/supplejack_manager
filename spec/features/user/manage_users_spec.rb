# frozen_string_literal: true
require 'rails_helper'

feature 'Admin user can manage other users', type: :feature do
  let(:all_users_page) { UsersPage.new }
  let!(:active_users) { create_list(:user, 3) }
  let!(:deactived_users) { create_list(:user, 3, active: false) }
  let(:admin_user) { create(:user, :admin, email: 'admin@test.com') }

  before do
    login_as(admin_user, scope: :user)
    all_users_page.load
  end

  scenario 'See a list of all active users' do
    expect(all_users_page.user_table).to have_content('John Doe', count: 4)
  end

  scenario 'See a list of all deactived users' do
    click_link 'Deactivated Users'
    expect(all_users_page.user_table).to have_content('John Doe', count: 3)
  end

  scenario 'Can create a new user' do
    new_user = build(:user)

    click_link 'New user'

    fill_in 'user[name]', with: new_user.name
    fill_in 'user[email]', with: new_user.email
    fill_in 'user[password]', with: 'secret'
    fill_in 'user[password_confirmation]', with: 'secret'

    click_button 'Create User'

    expect(all_users_page.user_table).to have_content('John Doe', count: 5)
  end
end
