# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Harvesting', type: :feature, js: true do
  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
    allow(AbstractJob).to receive(:search).and_return([])
    allow(Preview).to receive(:find) { build(:preview, id: 1, parser_id: parser.id) }
  end

  let(:user)        { create(:user, :admin) }
  let(:source)      { create(:source) }
  let!(:parser)     { create(:parser, source_id: source) }
  let!(:version)    { create(:version, versionable: parser, user_id: user, version: 'v5') }
  let(:harvest_job) { build(:harvest_job) }

  before do
    sign_in user

    visit parsers_path

    expect(page).to have_text parser.name
    click_link parser.name

    expect(page).to have_content(parser.name)
  end

  scenario 'A harvest operator can run a harvest' do
    click_link version.message

    click_button 'Tag as Staging'

    click_button 'Run Harvest'

    click_link 'Staging Harvest'

    expect(page).to have_text 'Run Staging Harvest'
    expect(page).to have_text 'Mode'
    expect(page).to have_css  '#harvest_job_mode_normal'
    expect(page).to have_css  '#harvest_job_mode_full_and_flush'

    expect(page).to have_text 'How many records do you wish to harvest?'
    expect(page).to have_css  '#harvest_job_limit'

    expect(page).to have_button 'Start Harvest'
  end

  scenario 'A harvest operator can Update a parser' do
    fill_code_mirror 'class Hey; end'
    fill_in 'parser_message', with: 'Updating Parser'
    click_button 'Update Parser Script'

    expect(page).to have_link 'Updating Parser'
  end

  scenario 'A harvest operator can update parser name and source' do
    click_link 'Change name or data source'

    expect(page).to have_current_path(edit_meta_parser_path(parser))

    fill_in 'parser_name', with: 'New Parser name'
    click_button 'Update Parser'

    expect(page).to have_current_path(edit_parser_path(parser))
  end

  scenario 'A harvest operator can disable Full & Flush harvest mode' do
    allow(HarvestSchedule).to receive(:update_schedulers_from_environment) { true }
    click_button 'Disable Full & Flush harvest mode'
    click_button 'Yes'

    expect(page).to have_text 'Enable Full & Flush harvest mode'
  end

  scenario 'A harvest operator can delete a parser script' do
    click_button 'Delete Parser Script'
    expect(page).to have_text 'Delete Parser'

    within '.delete-confirmation' do
      expect(page).to have_text 'Are you sure that you want to delete the parser:'
      expect(page).to have_text "#{parser.name}"
      expect(page).to have_text 'with version name:'
    end

    expect(page).to have_text 'Warning:'
    expect(page).to have_text 'You currently have scheduled jobs set for this parser.'
    expect(page).to have_text 'By deleting this parser the scheduled jobs will be deleted as well.'
    expect(page).to have_text 'Delete'
    expect(page).to have_text 'Cancel'
  end
end
