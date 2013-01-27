class Previewer

  attr_reader :parser, :loader, :syntax_error, :fetch_error, :index

  def initialize(parser, content, index=0)
    @parser = parser
    @parser.content = content if content.present?
    @loader = ParserLoader.new(parser)
    @index = index.to_i
    @syntax_error = nil
    @fetch_error = nil
  end

  def load_record
    begin
      loader.parser_class.records(limit: index+1).each_with_index do |record, i|
        return record if index == i
      end
      nil
    rescue StandardError => e
      @fetch_error = e.message
      return nil
    end
  end

  def record
    return nil if @record_not_found == true

    @record ||= begin
      if loader.loaded?
        record = load_record
        @record_not_found = true unless record
        record
      else
        @syntax_error = loader.syntax_error
        @record_not_found = true
      end
    end
  end

  def record?
    record
    !@record_not_found
  end

  def attributes_json
    JSON.pretty_generate(record.attributes)
  end

  def attributes_output
    CodeRay.scan(attributes_json, :json).html(:line_numbers => :table).html_safe
  end

  def pretty_xml_output
    record.raw_data
  end

  def pretty_json_output
    JSON.pretty_generate(record.raw_data)
  end

  def raw_output
    format = parser.xml? ? :xml : :json
    CodeRay.scan(self.send("pretty_#{format}_output"), format).html(line_numbers: :table).html_safe
  end

  def errors?
    record.errors.any?
  end

  def errors_json
    return nil unless record.errors.any?
    JSON.pretty_generate(record.errors)
  end

  def errors_output
    CodeRay.scan(errors_json, :json).html(:line_numbers => :table).html_safe if errors?
  end

end