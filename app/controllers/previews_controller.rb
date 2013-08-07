class PreviewsController < ApplicationController

	respond_to :js

	def show
		@preview = Preview.find(params[:id])
		respond_with @preview
	end
end
