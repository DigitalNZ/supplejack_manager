# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Harvesting', type: :feature, js: true do
  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
  end

  let(:user)    { create(:user, :admin) }
  let(:source)  { create(:source) }
  let!(:parser) { create(:parser, source_id: source) }
  let!(:version) { create(:version, versionable: parser, user_id: user) }

  scenario 'A harvest operator can trigger a harvest' do
    visit root_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_button 'Sign in'

    expect(page).to have_text('Supplejack Dashboard')

    visit parsers_path

    expect(page).to have_text parser.name

    click_link parser.name

    expect(page).to have_content(parser.name)
  end
end
