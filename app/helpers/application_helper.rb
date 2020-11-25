# frozen_string_literal: true

module ApplicationHelper
  include EnvironmentHelpers

  def custom_form_with(model: nil, scope: nil, url: nil, format: nil, **options, &block)
    options[:builder] = CustomFormBuilder
    form_with model: model, scope: scope, url: url, format: format, **options, &block
  end

  def custom_fields_for(object, options = {}, &block)
    options[:builder] = CustomFormBuilder
    fields_for(object, nil, options, &block)
  end

  def display_base_errors(resource)
    return '' if (resource.errors.empty?) || (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def link_to_tab(name, path, html_options = {})
    li_options = {}
    li_options.reverse_merge!({ class: 'active' }) if request.path == path
    content_tag(:li, link_to(name, path, html_options), li_options)
  end

  def pretty_format(parser_id, raw_data)
    parser = Parser.find(parser_id) rescue nil
    if parser.present?
      format = parser.xml? ? :xml : :json
      raw_data = JSON.pretty_generate(JSON.parse(raw_data)) if format == :json
      CodeRay.scan(raw_data, format).html(line_numbers: :table).html_safe
    else
      raw_data
    end
  end

  def format_backtrace(backtrace)
    content_tag 'div' do
      backtrace.each_with_index do |span_content, index|
        concat content_tag('small', span_content)
      end
    end
  end

  def safe_users_path(params = {})
    current_user.admin? ? users_path(params) : root_path
  end

  def can_show_button(action, object)
    can?(action, object) ? '' : 'disabled'
  end

  def parser_type_enabled
    ENV['PARSER_TYPE_ENABLED'] == 'true'
  end

  def human_duration(secs)
    return '' unless secs.present?

    secs = secs.to_i
    [[60, :sec],
     [60, :min],
     [24, :hr],
     [Float::INFINITY, :day]].map do |count, name|
      next unless secs.positive?

      secs, n = secs.divmod(count)
      "#{n.to_i} #{name}" unless n.to_i.zero?
    end.compact.reverse.join(' ')
  end
end
