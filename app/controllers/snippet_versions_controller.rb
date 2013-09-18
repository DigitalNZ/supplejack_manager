class SnippetVersionsController < ApplicationController

  before_filter :find_snippet
  before_filter :find_version, only: [:show, :update]

  respond_to :html, :json

  def current
    @version = @snippet.current_version(params[:environment])
    respond_with @version
  end

  def show
    respond_with @version, serializer: SnippetVersionSerializer
  end

  def update
    @version.update_attributes(params[:version])
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

end
