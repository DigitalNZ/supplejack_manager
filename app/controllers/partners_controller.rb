# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

class PartnersController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
  end

  def create
    if @partner.save
      redirect_to partners_path
    else
      render :new
    end
  end

  def edit
  end

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
