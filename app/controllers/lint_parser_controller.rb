# frozen_string_literal: true

class LintParserController < ApplicationController
  def show
    @parser = Parser.find(params[:id])

    create_tmp_file
    run_lingter
  end

  private
    def create_tmp_file
      file = File.new("tmp/parser_script-#{@parser.id}.rb", 'w')
      file << @parser.content
      file.close
    end

    def run_lingter
      @warnings = `bundle exec rubocop tmp/parser_script-#{@parser.id}.rb --format simple`
      @warnings.slice!("== tmp/parser_script-#{@parser.id}.rb ==")
    end

    def delete_tmp_file
      File.delete("tmp/parser_script-#{@parser.id}.rb")
    end
end
