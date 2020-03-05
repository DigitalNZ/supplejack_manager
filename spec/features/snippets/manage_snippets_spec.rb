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

  scenario 'See all snippets' do
    snippets.each do |snippet|
      expect(snippet_page.snippets_table).to have_content(snippet.name)
    end
  end

  scenario 'can create snippets with valid data' do
    click_link 'Create New Code Snippet'

    fill_in 'snippet[name]', with: new_snippet.name

    within '.CodeMirror' do
      current_scope.click
      field = current_scope.find('textarea', visible: false)
      field.send_keys new_snippet.content
    end

    click_button 'Create Snippet'

    expect(page).to have_content(new_snippet.name)
  end

  scenario 'can update snippet' do
    click_link snippets.first.name

    within '.CodeMirror' do
      current_scope.click
      field = current_scope.find('textarea', visible: false)
      field.send_keys 'Hello'
    end

    fill_in 'snippet[message]', with: 'A message'

    click_button 'Update Snippet'

    expect(page).to have_content(snippets.first.content + 'Hello')
  end

  scenario 'can see a old version of a snippet' do
    click_link snippets.first.name

    within '.CodeMirror' do
      current_scope.click
      field = current_scope.find('textarea', visible: false)
      field.send_keys 'abcdef'
    end

    fill_in 'snippet[message]', with: 'A message'

    click_button 'Update Snippet'

    within '.CodeMirror' do
      current_scope.click
      field = current_scope.find('textarea', visible: false)
      field.send_keys 'hide this message'
    end

    click_button 'Update Snippet'
    click_link 'A message'

    expect(page).not_to have_content('hide this message')
  end

  scenario 'can update snippet name' do
    click_link snippets.first.name
    click_link 'Rename Code Snippet'

    fill_in 'snippet[name]', with: 'New name'

    click_button 'Rename Snippet'

    expect(page).to have_content('New name')
  end

  scenario 'can delete snippet' do
    click_link snippets.first.name
    click_link 'Delete Code Snippet'
    click_button 'Delete'

    expect(page).not_to have_content(snippets.first.name)
  end
end
