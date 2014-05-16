# The majority of the Supplejack code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components licensed under the GPL or MIT licenses or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

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
