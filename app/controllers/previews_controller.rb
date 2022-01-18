# frozen_string_literal: true

# app/controllers/previews_controller.rb
class PreviewsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :find_preview, only: [:show, :update]

  def show
    respond_to do |format|
      format.js   { @preview }
      format.json { render json: @preview }
    end
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

    def preview_params
      params.require(:preview).permit(:raw_data, :harvested_attributes, :api_record,
                                      :status, :deletable, :field_errors, :validation_errors,
                                      :harvest_failure, :harvest_job_errors,
                                      :format, harvest_job: [:parser_code, :parser_id, :environment, :index, :limit, :user_id])
    end
end
