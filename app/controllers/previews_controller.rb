# The majority of The Supplejack Manager code is Crown copyright (C) 2014,
# New Zealand Government,
# and is licensed under the GNU General Public License, version 3.
# Some components are third party components that are licensed under
# the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and
# the Department of Internal Affairs.
# http://digitalnz.org/supplejack

# app/controllers/previews_controller.rb
class PreviewsController < ApplicationController
  respond_to :js
  skip_before_action :verify_authenticity_token

  def show
    @preview = Preview.find(params[:id])
    respond_with @preview
  end
end
