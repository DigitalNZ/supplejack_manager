# frozen_string_literal: true

class SnippetEditPage < ApplicationPage
  set_url '/snippets/${id}/edit'

  elements :snippet_versions, '.version a'
end
