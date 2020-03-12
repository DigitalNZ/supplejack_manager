# frozen_string_literal: true

class CustomFormBuilder < ActionView::Helpers::FormBuilder
  def errors(method, options)
    # errors from source or source_id are refering to the Source model
    errors = object.errors[method] + object.errors[method.to_s.gsub(/_id$/, '')]

    errors.uniq.map do |error_msg|
      @template.content_tag(:small, error_msg, class: :error)
    end.join.html_safe
  end

  def error_wrapper(method, options, &block)
    block.call + errors(method, options)
  end

  %w[
    text_field
    text_area
    password_field
    search_field
    telephone_field
    date_field
    datetime_local_field
    month_field
    week_field
    url_field
    email_field
    color_field
    time_field
    number_field
    range_field
  ].each do |field_type|
    define_method(field_type) do |method, options = {}|
      disable_errors_display = options.delete(:disable_errors_display)

      return super(method, options) if disable_errors_display

      error_wrapper(method, options) do
        super(method, options)
      end
    end
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    error_wrapper(method, options) do
      super(method, choices, options, html_options, &block)
    end
  end

  def grouped_collection_select(method, collection, group_method, group_label_method, option_key_method, option_value_method, options = {}, html_options = {})
    error_wrapper(method, options) do
      super(method, collection, group_method, group_label_method, option_key_method, option_value_method, options, html_options)
    end
  end

  def text_field_submit(method, options = {})
    submit_text = options.delete(:submit_text) || 'Submit'
    @template.content_tag(:div, class: 'input-group') do
      text_field(method, options.merge(disable_errors_display: true)) +
      @template.content_tag(:div, class: 'input-group-button') do
        submit(submit_text, class: 'button')
      end
    end + errors(method, options)
  end
end
