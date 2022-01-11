# frozen_string_literal: true

class ParserLinter
  attr_reader :parser, :tempfile, :warnings

  def initialize(parser)
    @parser = parser
    @tempfile = "tmp/parser_script-#{@parser.id}.rb"
  end

  def lint
    create_tmp_file
    run_lingter
    delete_tmp_file

    @warnings
  end

  private
    def create_tmp_file
      file = File.new(@tempfile, 'w')
      file << @parser.content
      file.close
    end

    def run_lingter
      @warnings = `bundle exec rubocop #{@tempfile} --format simple`
      @warnings.slice!("== #{@tempfile} ==")
    end

    def delete_tmp_file
      File.delete(@tempfile)
    end
end
