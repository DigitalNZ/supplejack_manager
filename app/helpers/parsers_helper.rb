module ParsersHelper

  def link_to_next(parser_id, index, html_options={})
    link_to "", records_path(parser_id, index: index.to_i+1), html_options
  end

  def link_to_previous(parser_id, index, html_options={})
    index = index.to_i - 1

    if index >= 0
      link_to "", records_path(parser_id, index: index.to_i), html_options
    else
      html_options[:class] << " disabled"
      content_tag(:span, "", html_options)
    end
  end
end
