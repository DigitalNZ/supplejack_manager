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

  def environment_tags(version, parser)
    current_staging = parser.current_version(:staging)
    current_production = parser.current_version(:production)

    if version == current_staging && version == current_production
      environment_tag(:staging, environment_tag(:production))
    elsif version == current_staging
      environment_tag(:staging)
    elsif version == current_production
      environment_tag(:production)
    else
      content_tag(:div, "", class: "version-bubble-container") do
        bubbles = []
        version.tags ||= []
        version.tags.each do |environment|
          bubbles << content_tag(:span, environment.capitalize.first, class: "version-bubble #{environment}")
        end
        safe_join(bubbles)
      end
    end
  end

  def environment_tag(environment, nested_tag=nil)
    content_tag(:span, safe_join([content_tag(:span, "", class: "arrow arrow-left"), t("parsers.environments.#{environment}"), nested_tag]), class: "version-tag #{environment}")
  end
end
