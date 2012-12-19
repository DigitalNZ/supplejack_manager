class Previewer

  attr_reader :parser, :data

  def initialize(parser, data)
    @parser = parser
    @data = data
  end

  def path
    @path ||= Rails.root.to_s + "/tmp/parsers/#{parser.strategy}/#{parser.name}"
  end

  def create_tempfile
    FileUtils.mkdir_p("#{Rails.root.to_s}/tmp/parsers/#{parser.strategy}")
    File.open(path, "w") {|f| f.write(data) }
  end

  def klass
    parser.name.gsub(/\.rb/, "").classify.constantize
  end

  def record
    create_tempfile
    load(path)
    klass.records(limit: 1).first
  end

  def pretty_json
    JSON.pretty_generate(record.attributes)
  end

  def pretty_output
    CodeRay.scan(pretty_json, :json).html(:line_numbers => :table).html_safe
  end

end