# frozen_string_literal: true
require 'rails_helper'

feature 'Testing capybara', type: :feature, vcr: true do
  before do
    visit root_path
  end

  scenario 'A user can see the correct page title', js: true do
    expect(page.title).to include 'Harvester Manager'
  end
end
