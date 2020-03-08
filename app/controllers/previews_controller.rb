# frozen_string_literal: true

# app/controllers/previews_controller.rb
class PreviewsController < ApplicationController
  respond_to :js
  skip_before_action :verify_authenticity_token

  def show
    @preview = Preview.find(params[:id])
    respond_with @preview
  end
end
