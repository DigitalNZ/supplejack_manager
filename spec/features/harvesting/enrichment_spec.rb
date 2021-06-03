# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Enrichment Spec', js: true do
  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
    allow(AbstractJob).to receive(:search).and_return([])
  end

  let(:user)    { create(:user, :admin) }
  let(:source)  { create(:source) }
  let!(:enrichment) { create(:parser, :enrichment, source_id: source) }
  let!(:version) { create(:version, :enrichment, versionable: enrichment, user_id: user, tags: ['staging'], version: 'v3') }

  before do
    sign_in user

    visit parsers_path

    expect(page).to have_text enrichment.name
    click_link enrichment.name

    expect(page).to have_content(enrichment.name)
  end

  scenario 'A harvest operator can run an enrichment' do
    click_link version.message

    find('.run-enrichment').click
    click_link 'Staging Enrichment'

    expect(page).to have_text 'Run Staging Enrichment'

    expect(page).to have_text 'Record'

    expect(page).to have_button 'Start Enrichment'
  end
end
