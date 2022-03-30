# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Manage snippets', type: :feature, js: true do
  let(:snippet_page) { SnippetsPage.new }
  let(:admin_user) { create(:user, :admin) }
  let(:new_snippet) { build(:snippet) }
  let!(:snippets) do
    create_list(:snippet, 3)
  end

  before do
    login_as(admin_user, scope: :user)
    snippet_page.load
  end

  def fill_and_submit_snippet(code, message, button = 'Update Snippet')
    fill_code_mirror code

    fill_in 'snippet[message]', with: message unless message.empty?

    click_button button
  end

  scenario 'See all snippets' do
    snippets.each do |snippet|
      expect(snippet_page.snippets_table).to have_content(snippet.name)
    end
  end

  scenario 'can create snippets with valid data' do
    click_link 'Create New Code Snippet'

    fill_in 'snippet[name]', with: new_snippet.name
    fill_and_submit_snippet(new_snippet.content, '', 'Create Snippet')

    expect(page).to have_content(new_snippet.name)
  end

  scenario 'can update snippet' do
    click_link snippets.first.name
    fill_and_submit_snippet('my code', 'A message')

    expect(page).to have_content(snippets.first.content + 'my code')
  end

  scenario 'can see an old version of a snippet' do
    click_link snippets.first.name

    fill_and_submit_snippet('abcdef', 'A message')
    fill_and_submit_snippet('hide this message', 'New message')

    click_link 'A message'

    expect(page).not_to have_content('hide this message')
  end

  scenario 'can update snippet name' do
    click_link snippets.first.name
    click_button 'Rename Code Snippet'

    fill_in 'snippet[name]', with: 'New name'

    click_button 'Rename'

    expect(page).to have_content('New name')
  end

  scenario 'can delete snippet', skip: 'TODO: turn it on after OR fix after https://www.pivotaltracker.com/story/show/181652360' do
    click_link snippets.first.name
    click_button 'Delete Code Snippet'
    click_button 'Delete'

    expect(page).not_to have_content(snippets.first.name)
  end
end
