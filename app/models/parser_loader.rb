class ParserLoader

  attr_accessor :parser, :syntax_error

  def initialize(parser)
    @parser = parser
    @loaded = nil
  end

  def path
    @path ||= Rails.root.to_s + "/tmp/parsers/#{parser.strategy}/#{parser.name}"
  end

  def create_tempfile
    FileUtils.mkdir_p("#{Rails.root.to_s}/tmp/parsers/#{parser.strategy}")
    File.open(path, "w") {|f| f.write(parser.data) }
  end

  def parser_class
    parser.name.gsub(/\.rb/, "").camelize.constantize
  end

  def load_parser
    return @loaded unless @loaded.nil?

    begin
      create_tempfile
      load(path)
      @loaded = true
    rescue SyntaxError => e
      @syntax_error = e.message
      @loaded = false
    end
  end

  def loaded?
    load_parser
    @loaded
  end
end