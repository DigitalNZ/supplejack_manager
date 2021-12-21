# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Manage parser', type: :feature, js: true do
  let(:parsers_page) { ParsersPage.new }
  let(:admin_user) { create(:user, :admin) }
  let!(:parsers) do
    allow_any_instance_of(Source).to receive(:update_apis)
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
    create_list(:parser, 3)
  end


  before do
    login_as(admin_user, scope: :user)
    parsers_page.load
  end

  scenario 'Do a quick search by default' do
    expect(parsers_page.selected_search['value']).to eq 'quick_search'
  end

  scenario 'Searching a parser name' do
    fill_in 'Search:', with: Parser.first.name

    # check that only 1 parser is found
    find('tbody tr:only-child') # forces capybara to wait for the async request
    expect(parsers_page.table_rows.count).to eq 1

    # check that the right parser is found
    expect(parsers_page.parser_table.find('tbody > tr > td:first-child').text).to eq Parser.first.name
  end

  scenario 'Searching a parser content' do
    # select the content search and search for a specific word from the first parser content
    parsers_page.content_search_radio.click
    random_last_name_from_faker = Parser.first.content.match(/%r{(.*)}/)[1]
    fill_in 'Search:', with: random_last_name_from_faker

    # check that only 1 parser is found
    find('tbody tr:only-child') # forces capybara to wait for the async request
    expect(parsers_page.table_rows.count).to eq 1

    # check that the right parser is found
    expect(parsers_page.parser_table.find('tbody > tr > td:first-child').text).to eq Parser.first.name
  end
end
