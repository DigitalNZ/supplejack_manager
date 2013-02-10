class SnippetsController < ApplicationController

  respond_to :html, :json

  def index
    @snippets = Snippet.all
  end

  def new
    @snippet = Snippet.new
  end

  def edit
    @snippet = Snippet.find(params[:id])
  end

  def create
    @snippet = Snippet.new(params[:snippet])
    @snippet.user_id = current_user.id

    if @snippet.save
      redirect_to edit_snippet_path(@snippet)
    else
      render :new
    end
  end

  def update
    @snippet = Snippet.find(params[:id])
    @snippet.user_id = current_user.id

    if @snippet.update_attributes(params[:snippet])
      redirect_to edit_snippet_path(@snippet)
    else
      render :edit
    end
  end

  def search
    @snippet = Snippet.find_by_name(params[:name])
    respond_with @snippet
  end
end