# frozen_string_literal: true

# PreviewersController
class PreviewersController < ApplicationController
  before_action :set_previewer, :validate_parser_content

  # The reason why a create(POST) method is required
  # is because the whole content of the parser form
  # is posted here and get cant handle that amount
  # of data. This is called from a JS method.
  def create
    params[:environment] ||= 'staging'
    set_worker_environment_for(HarvestJob)

    render layout: false
  end

  # Initializes Previewer
  #
  # @author Eddie
  # @last_modified Eddie
  def set_previewer
    @parser = Parser.find(params[:parser_id])
    @previewer = Previewer.new(@parser, params[:parser][:content],
                               current_user.id, params[:index],
                               params[:review])
    @previewer.create_preview_job
  end

  # Parse Ruby code in Parser and set error
  #
  # @author Eddie
  # @last_modified Eddie
  def validate_parser_content
    eval params[:parser][:content]
    @parser_error = nil
  rescue => error
    @parser_error = { type: error.class, message: error.message }
  rescue SyntaxError => error
    @parser_error = { type: error.class, message: error.message }
  end
end
