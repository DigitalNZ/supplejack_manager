# frozen_string_literal: true

module PreviewHelper
  def pretty_json(data_str)
    return '' if data_str.blank?

    JSON.pretty_generate(JSON.parse(data_str))
  end

  def pretty_xml(raw_data_str)
    raw_data_str
  end

  def pretty_raw_data(preview)
    send("pretty_#{preview.format}", preview.raw_data)
  end
end
