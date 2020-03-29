# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Harvest Schedule Spec', js: true do
  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
  end

  let(:user)    { create(:user, :admin) }
  let(:source)  { create(:source) }
  let!(:parser) { create(:parser, :enrichment, source_id: source) }
  let!(:version) { create(:version, versionable: parser, user_id: user) }

  before do
    sign_in user

    visit environment_harvest_schedules_path('test')

    click_link 'New Schedule'
  end

  scenario 'A harvest operator can create and edit a harvest schedule' do
    select(parser.name, from: 'Parser Script')
    choose('Full And Flush')
    check('Test Enrich')
    click_button('Save Schedule')
    click_link('Edit')
    expect(page).to have_field('Test Enrich', checked: true)
    choose('Normal')
    uncheck('Test Enrich')
    click_button('Save Schedule')
    expect(page).to have_link(parser.name)
  end

  scenario 'A harvest operator can create and delete a harvest schedule' do
    select(parser.name, from: 'Parser Script')
    choose('Full And Flush')
    check('Test Enrich')
    click_button('Save Schedule')
    click_link('Delete')
    expect(page).not_to have_text(parser.name)
    expect(page).to have_text('No data available in table')
  end
end