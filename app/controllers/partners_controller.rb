# frozen_string_literal: true

# app/controllers/partners_controller.rb
class PartnersController < ApplicationController
  load_and_authorize_resource

  def index
    @partners = Partner.all
  end

  def new; end

  def create
    if @partner.save
      redirect_to partners_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @partner.update_attributes(partner_params)
      redirect_to partners_path, notice: 'partner was successfully updated.'
    else
      render :edit
    end
  end

  private
    def partner_params
      params.require(:partner).permit(:name)
    end
end
