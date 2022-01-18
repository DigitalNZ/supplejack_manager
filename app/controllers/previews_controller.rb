# frozen_string_literal: true

# app/controllers/previews_controller.rb
class PreviewsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :find_preview, only: [:show, :update]
  before_action :find_parser, :validate_parser_content, only: [:create]

  def show
    respond_to do |format|
      format.js   { @preview }
      format.json { render json: @preview }
    end
  end

  def create
    @preview = Preview.create(
      parser_code: params[:parser][:content],
      parser_id: @parser.id,
      index: params[:index],
      format: @parser.xml? ? 'xml' : 'json',
      user_id: current_user.id,
      status: 'New preview record initialised. Waiting in queue...'
    )

    params[:environment] ||= 'staging'
    set_worker_environment_for(HarvestJob)

    job = HarvestJob.create(
      parser_code: params[:parser][:content],
      parser_id: @parser.id,
      environment: 'preview',
      index: params[:index].to_i,
      limit: params[:index].to_i + 1,
      user_id: current_user.id
    )
    @preview.start_preview_worker(job.id)

    render layout: false
  end

  def update
    if @preview.update_attributes(preview_params)
      render json: @preview
    else
      render json: { preview: @preview }, status: :bad_request
    end
  end

  private
    def find_preview
      @preview = Preview.find(params[:id])
    end

    def find_parser
      @parser = Parser.find(params[:parser][:id])
    end

    def preview_params
      params.require(:preview).permit(:raw_data, :harvested_attributes, :api_record,
                                      :status, :deletable, :field_errors, :validation_errors,
                                      :harvest_failure, :harvest_job_errors,
                                      :format, harvest_job: [:parser_code, :parser_id, :environment, :index, :limit, :user_id])
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
