# frozen_string_literal: true

class PreviewersController < ApplicationController
  before_action :find_parser, :validate_parser_content

  def create
    @preview = Preview.create(parser_code: params[:parser][:content],
                              parser_id: @parser.id,
                              index: params[:index],
                              format: @parser.xml? ? 'xml' : 'json',
                              user_id: current_user.id)

    params[:environment] ||= 'staging'
    set_worker_environment_for(HarvestJob)

    render layout: false
  end

  def find_parser
    @parser = Parser.find(params[:parser_id])
  end

  def validate_parser_content
    eval params[:parser][:content]
    @parser_error = nil
  rescue => error
    @parser_error = { type: error.class, message: error.message }
  rescue SyntaxError => error
    @parser_error = { type: error.class, message: error.message }
  end
end
