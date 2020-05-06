# frozen_string_literal: true

# app/controllers/snippet_versions_controller.rb
class SnippetVersionsController < ApplicationController
  before_action :find_snippet
  before_action :find_version, only: [:show, :update]

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
      # Rails removes empty arrays from params so no top level key
      return {} if params[:version].blank?

      params
        .require(:version)
        .permit(:content, tags: [])
    end
end
