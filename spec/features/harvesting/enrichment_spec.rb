# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Enrichment Spec', js: true do
  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
    allow(AbstractJob).to receive(:search).and_return([])

    allow(Preview).to receive(:find) { build(:preview, id: 1) }
  end

  let(:user)    { create(:user, :admin) }
  let(:source)  { create(:source) }
  let!(:parser) { create(:parser, :enrichment, source_id: source) }
  let!(:version) { create(:version, :enrichment, versionable: parser, user_id: user, tags: ['staging']) }

  before do
    visit root_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_button 'Sign in'

    visit parsers_path

    expect(page).to have_text parser.name
    click_link parser.name

    expect(page).to have_content(parser.name)
  end

  scenario 'A harvest operator can run an enrichment' do
    click_link version.message

    find('.run-enrichment').click
    click_link 'Staging Enrichment'

    expect(page).to have_text 'Run Staging Enrichment'

    expect(page).to have_text 'Record'

    expect(page).to have_text 'Select the enrichment you would like to run'
    expect(page).to have_text 'Test Enrich'
    expect(page).to have_button 'Start Enrichment'
  end
end
