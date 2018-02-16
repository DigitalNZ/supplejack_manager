# frozen_string_literal: true
require 'rails_helper'

feature 'Manage sources', type: :feature, js: true do
  let(:all_sources_page) { SourcesPage.new }
  let(:admin_user) { create(:user, :admin) }
  let!(:sources) do
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
    create_list(:source, 3)
  end

  before do
    login_as(admin_user, scope: :user)
    all_sources_page.load
  end

  scenario 'See all sources' do
    expect(all_sources_page.source_table).to have_content('A Source')
  end

  context 'Create a new source' do
    scenario 'valid data' do
      new_source = build(:source)

      click_link 'New Data Source'

      fill_in 'source[name]', with: new_source.name
      select sources.first.partner.name

      click_button 'Create Data Source'

      expect(all_sources_page.source_table).to have_content('A Source', count: 4)
    end
  end

  scenario 'Update a source' do
    click_link sources.first.name

    fill_in 'source[name]', with: 'Updated name!!'

    click_button 'Update Data Source'

    expect(all_sources_page.source_table).to have_content('Updated name!!')
    expect(all_sources_page).to have_flash_success
  end
end
