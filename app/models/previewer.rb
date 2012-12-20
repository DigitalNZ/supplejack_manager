class Previewer

  attr_reader :parser, :data, :syntax_error

  def initialize(parser, data)
    @parser = parser
    @data = data
    @syntax_error = nil
  end

  def path
    @path ||= Rails.root.to_s + "/tmp/parsers/#{parser.strategy}/#{parser.name}"
  end

  def create_tempfile
    FileUtils.mkdir_p("#{Rails.root.to_s}/tmp/parsers/#{parser.strategy}")
    File.open(path, "w") {|f| f.write(data) }
  end

  def klass_name
    parser.name.gsub(/\.rb/, "").camelize
  end

  def klass
    klass_name.constantize
  end

  def load_parser
    begin
      create_tempfile
      load(path)
      return true
    rescue SyntaxError => e
      @syntax_error = e.message
      return false
    end
  end

  def record
    return nil if @record_not_found == true

    @record ||= begin
      if load_parser
        record = klass.records(limit: 1).first
        @record_not_found = true unless record
        record
      else
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