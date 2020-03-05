# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Manage sources', type: :feature, js: true do
  let(:all_sources_page) { SourcesPage.new }
  let(:admin_user) { create(:user, :admin) }
  let!(:sources) do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
    create_list(:source, 3)
  end

  before do
    login_as(admin_user, scope: :user)
    all_sources_page.load
  end

  scenario 'See all sources' do
    sources.each do |source|
      expect(all_sources_page.source_table).to have_content(source.source_id)
    end
  end

  context 'Create a new source' do
    scenario 'valid data' do
      new_source = build(:source)

      click_link 'New Data Source'

      fill_in 'source[source_id]', with: new_source.source_id
      select sources.first.partner.name

      click_button 'Create Data Source'

      sources.each do |source|
        expect(all_sources_page.source_table).to have_content(source.source_id)
      end
      expect(all_sources_page.source_table).to have_content(new_source.source_id)
    end
  end

  scenario 'Update a source' do
    new_partner = create(:partner)

    click_link sources.first.source_id

    select new_partner.name

    click_button 'Update Data Source'

    expect(all_sources_page.source_table).to have_content(new_partner.name)
    expect(all_sources_page).to have_flash_success
  end
end
