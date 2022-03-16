# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Manage parser', type: :feature, js: true do
  let(:parser_templates_page) { ParserTemplatesPage.new }
  let(:admin_user)            { create(:user, :admin)   }
  let(:new_parser_template)   { build(:parser_template) }

  let!(:parser_templates) do
    create_list(:parser_template, 3)
  end

  before do
    login_as(admin_user, scope: :user)
    parser_templates_page.load
  end

  scenario 'can create parser template with valid data' do
    click_link 'Create New Parser Template'

    fill_in 'parser_template[name]', with: new_parser_template.name
    fill_code_mirror new_parser_template.content

    click_button 'Create Parser template'

    expect(page).to have_content(new_parser_template.name)
  end

  scenario 'can update parser script' do
    click_link parser_templates.first.name

    fill_code_mirror 'Hello'

    click_button 'Update Parser template'

    expect(page).to have_content(parser_templates.first.content + 'Hello')
  end

  scenario 'can update parser script name' do
    click_link parser_templates.first.name
    click_button 'Rename Parser Template'

    fill_in 'parser_template[name]', with: 'New name'

    click_button 'Rename'

    expect(page).to have_content('New name')
  end

  scenario 'can delete parser script' do
    click_link parser_templates.first.name
    click_button 'Delete Parser Template'
    click_button 'Delete'

    expect(page).not_to have_content(parser_templates.first.name)
  end
end
