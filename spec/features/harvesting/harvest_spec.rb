# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Harvesting', type: :feature, js: true do
  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
    allow(AbstractJob).to receive(:search).and_return([])

    allow(Preview).to receive(:find) { build(:preview, id: 1) }
  end

  let(:user)    { create(:user, :admin) }
  let(:source)  { create(:source) }
  let!(:parser) { create(:parser, source_id: source) }
  let!(:version) { create(:version, versionable: parser, user_id: user) }

  before do
    sign_in user

    visit parsers_path

    expect(page).to have_text parser.name
    click_link parser.name

    expect(page).to have_content(parser.name)
  end

  scenario 'A harvest operator can run a harvest' do
    click_link version.message

    click_link 'Tag as Staging'

    find('.run-harvest').click

    click_link 'Staging Harvest'

    expect(page).to have_text 'Run Staging Harvest'
    expect(page).to have_text 'Mode'
    expect(page).to have_css  '#harvest_job_mode_normal'
    expect(page).to have_css  '#harvest_job_mode_full_and_flush'

    expect(page).to have_text 'How many records do you wish to harvest?'
    expect(page).to have_css  '#harvest_job_limit'

    expect(page).to have_button 'Start Harvest'
  end

  scenario 'A harvest operator can preview a harvest' do
    allow_any_instance_of(Previewer).to receive(:create_preview_job) { true }
    click_link 'Preview'

    expect(page).to have_text 'Previewing records'
    expect(page).to have_text 'Previewing records Status: Initialising preview record...'
    expect(page).to have_text 'x'

    expect(page).to have_css '.tabs'

    expect(page).to have_text 'Source Data'
    expect(page).to have_text 'Harvested Attributes'
    expect(page).to have_text 'API Record'

    expect(page).to have_text '< previous'
    expect(page).to have_text ' - Preview Record - '
    expect(page).to have_text 'next'
  end

  scenario 'A harvest operator can Update a parser' do
    fill_code_mirror 'class Hey; end'
    fill_in 'parser_message', with: 'Updating Parser'

    click_button 'Update Parser Script'
    expect(page).to have_link 'Updating Parser'
  end

  scenario 'A harvest operator can rename a parser' do
    click_button 'Rename Parser'
    fill_in 'parser_name', with: 'Parser Name'
    click_button 'Rename Parser', match: :first
    expect(page).to have_link 'Parser Name'
  end

  scenario 'A harvest operator can change the data source of a parser' do
    click_button('Change Data Source')
    expect(page).to have_text 'Change source'
    expect(page).to have_text 'Warning: changing the source of this parser does not affect records that have already been harvested.'
    expect(page).to have_text 'Contributor'
    expect(page).to have_text ' Data Source'
    click_button 'Change source'
  end

  scenario 'A harvest operator can disable Full & Flush harvest mode' do
    allow(HarvestSchedule).to receive(:update_schedulers_from_environment) { true }
    click_link 'Disable Full & Flush harvest mode'
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_text 'Enable Full & Flush harvest mode'
  end

  scenario 'A harvest operator can delete a parser script' do
    click_button 'Delete Parser Script'
    expect(page).to have_text 'Delete Parser'
    expect(page).to have_text "Are you sure that you want to delete the parser: #{parser.name} with version name: new test version? Warning: You currently have scheduled jobs set for this parser. By deleting this parser the scheduled jobs will be deleted as well."
    expect(page).to have_text 'Delete'
    expect(page).to have_text 'Cancel'
  end
end
