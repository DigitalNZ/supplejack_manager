# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

# app/controllers/snippet_versions_controller.rb
class SnippetVersionsController < ApplicationController
  before_action :find_snippet
  before_action :find_version, only: [:show, :update]

  skip_before_action :authenticate_user!

  respond_to :html, :json

  def current
    @version = @snippet.current_version(params[:environment])
    respond_with @version
  end

  def show
    respond_with @version, serializer: SnippetVersionSerializer
  end

  def update
    @version.update_attributes(snippet_version_params)
    @version.post_changes
    redirect_to snippet_snippet_version_path(@snippet, @version)
  end

  private

  def find_snippet
    @snippet = Snippet.find(params[:snippet_id])
  end

  def find_version
    @version = @snippet.find_version(params[:id])
  end

  def snippet_version_params
    params.require(:version).permit!
  end
end
