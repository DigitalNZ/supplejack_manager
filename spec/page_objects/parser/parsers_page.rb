# frozen_string_literal: true

class ParsersPage < ApplicationPage
  set_url '/parsers'

  element :parser_table, '#parsers'
  elements :table_rows, '#parsers tbody tr'

  element :selected_search, 'input[type="radio"]:checked'
  element :quick_search_radio, 'input[value="quick_search"]'
  element :content_search_radio, 'input[value="content_search"]'
end
