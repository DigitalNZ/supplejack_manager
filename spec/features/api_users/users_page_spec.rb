# frozen_string_literal: true
require 'rails_helper'

feature 'API Users Page', type: :feature do
  before do
    visit root_path
  end

  scenario 'can be access from the home page navigation', do
    visit root_path
    # click on nav item
    expect(page.current_path).to eq environment_admin_users_path
  end
end
