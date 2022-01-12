# frozen_string_literal: true

class ParserLinter
  attr_reader :parser, :tempfile, :warnings, :warnings_count

  def initialize(parser)
    @parser = parser
    @tempfile = "tmp/parser_script-#{@parser.id}.rb"
  end

  def lint
    create_tmp_file
    run_rubocop
    delete_tmp_file

    self
  end

  private
    def create_tmp_file
      file = File.new(@tempfile, 'w')
      file << @parser.content
      file.close
    end

    def run_rubocop
      result = `bundle exec rubocop #{@tempfile} --format simple`
      results = result.split("\n")
      @warnings_count = results.last.scan(/\d* offenses detected/).last
      results.pop
      @warnings = results.drop(1)
    end

    def delete_tmp_file
      File.delete(@tempfile)
    end
end
