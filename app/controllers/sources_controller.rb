# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

class SourcesController < ApplicationController
  load_and_authorize_resource

  respond_to :html, :json
  
  def index
    @sources = params[:source].present? ? Source.where(params[:source]) : Source.all
    respond_with @sources
  end

  def show
    respond_with @source
  end

  def new
    @source.partner = Partner.new

    if can? :manage, Partner
      @partners = Partner.asc(:name)
    else
      @partners = Partner.find(current_user.manage_partners)
    end
  end

  def edit
    if can? :manage, Partner
      @partners = Partner.asc(:name)
    else
      @partners = Partner.find(current_user.manage_partners)
    end
  end

  def create
    if @source.save
      redirect_to sources_path, notice: 'Source was successfully created.'
    else
      render :new
    end
  end

  def update
    if @source.update_attributes(params[:source])
      redirect_to sources_path, notice: 'Source was successfully updated.'
    else
      render :edit
    end
  end

  def reindex
    @source = Source.find(params[:id])
    url = Figaro.env(params[:env])['API_HOST']
    RestClient.get("#{url}/manager/sources/#{@source.id}/reindex?date=#{params[:date]}")
  end
end
