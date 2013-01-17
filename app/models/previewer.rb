class Previewer

  attr_reader :parser, :loader, :syntax_error, :fetch_error

  def initialize(parser, data)
    @parser = parser
    @parser.data = data
    @loader = ParserLoader.new(parser)
    @syntax_error = nil
    @fetch_error = nil
  end

  def load_record
    begin
      loader.parser_class.records(limit: 1).first
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