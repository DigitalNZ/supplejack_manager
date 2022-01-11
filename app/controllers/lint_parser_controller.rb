# frozen_string_literal: true

class LintParserController < ApplicationController
  def show
    @parser = Parser.find(params[:id])
    @linter = ParserLinter.new(@parser).lint
  end
end
