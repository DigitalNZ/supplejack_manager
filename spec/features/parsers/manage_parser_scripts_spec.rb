# frozen_string_literal: true
require 'rails_helper'

feature 'Manage parser', type: :feature, js: true do
  let(:parser_page) { ParsersPage.new }
  let(:admin_user) { create(:user, :admin) }
  let!(:parsers) do
    allow_any_instance_of(Source).to receive(:update_apis)
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
    create_list(:parser, 3)
  end

  before do
    login_as(admin_user, scope: :user)
    parser_page.load
  end

  scenario 'See all parsers' do
    parsers.each do |parser|
      expect(parser_page.parser_table).to have_content(parser.name)
    end
  end

  scenario 'Only list sources within the selected partner' do
    partner = create(:source, name: 'Source to be listed').partner
    orphan_source = create(:source, name: 'Source not to be listed')
    parser_form_page = ParserFormPage.new

    click_link 'New Parser Script'
    select partner.name

    expect(parser_form_page.parser_source_dropdown).to have_content(partner.sources.first.name)
    expect(parser_form_page.parser_source_dropdown).not_to have_content(orphan_source.name)
  end

  context 'Create a new parser script' do
    let(:new_parser) { build(:parser) }
    let(:partner) { Partner.first }

    before do
      click_link 'New Parser Script'

      fill_in 'parser[name]', with: new_parser.name
      select partner.name
      select partner.sources.first.name
    end

    scenario 'valid JSON parser' do
      select 'JSON'

      click_button 'Create Parser Script'

      expect(page).to have_content("class #{new_parser.name} < SupplejackCommon::Json::Base")
    end

    scenario 'valid RSS parser' do
      select 'RSS'

      click_button 'Create Parser Script'

      expect(page).to have_content("class #{new_parser.name} < SupplejackCommon::Rss::Base")
    end

    scenario 'valid XML/HTML parser' do
      select 'XML/HTML'

      click_button 'Create Parser Script'

      expect(page).to have_content("class #{new_parser.name} < SupplejackCommon::Xml::Base")
    end

    scenario 'valid OAI parser' do
      select 'OAI'

      click_button 'Create Parser Script'

      expect(page).to have_content("class #{new_parser.name} < SupplejackCommon::Oai::Base")
    end
  end
end
