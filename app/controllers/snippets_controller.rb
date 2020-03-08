# frozen_string_literal: true

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
