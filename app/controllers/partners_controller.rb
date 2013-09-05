class PartnersController < ApplicationController

  def index
    @partners = Partner.all
  end

  def new
    @partner = Partner.new
  end

  def create
    @partner = Partner.new(params[:partner])

    if @partner.save
      redirect_to partners_path
    else
      render :new
    end
  end

  def edit
    @partner = Partner.find params[:id]
  end

  def update
    @partner = Partner.find(params[:id])

    if @partner.update_attributes(params[:partner])
      redirect_to partners_path, notice: 'partner was successfully updated.'
    else
      render :edit
    end
  end
end
