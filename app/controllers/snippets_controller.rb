# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

class SnippetsController < ApplicationController
  load_and_authorize_resource except: :current_version

  respond_to :html, :json

  def index
    @snippets = Snippet.all
  end

  def new; end

  def edit; end

  def create
    @snippet.user_id = current_user.id

    if @snippet.save
      redirect_to edit_snippet_path(@snippet)
    else
      render :new
    end
  end

  def update
    @snippet.user_id = current_user.id

    if @snippet.update_attributes(snippet_params)
      redirect_to edit_snippet_path(@snippet)
    else
      render :edit
    end
  end

  def destroy
    @snippet.destroy
    redirect_to snippets_path
  end

  def current_version
    @snippet = Snippet.find_by_name(params[:name], params[:environment])
    respond_with @snippet
  end

  def snippet_params
    params.require(:snippet).permit(:name, :content, :environment, :message).to_h
  end
end
