# frozen_string_literal: true
class SnippetsPage < ApplicationPage
  set_url '/snippets'

  element :snippets_table, '#snippets'
end
