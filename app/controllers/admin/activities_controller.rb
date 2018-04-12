# frozen_string_literal: true

module Admin
  # app/controllers/admin/activities_controller.rb
  class ActivitiesController < Admin::ApplicationController
    respond_to :csv, only: :index

    def index
      @activities = Admin::Activity.new(params[:environment]).all
    end
  end
end
