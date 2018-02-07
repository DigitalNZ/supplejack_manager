# frozen_string_literal: true

module Admin
  # app/controllers/admin/users_controller.rb
  class UsersController < ApplicationController
    respond_to :csv, only: :index

    def index
      @users = admin_users_request.all
      @total = (admin_users_request.total / 10.00).ceil || 1
      @page = params[:page].try(:to_i) || 1
    end

    def edit
      @user = Admin::User.new(params[:environment]).find(params[:id])
    end

    def update
      if Admin::User.new(params[:environment]).update(params[:id], params[:max_requests])
        redirect_to environment_admin_users_path
      else
        render :edit
      end
    end

    private

    def admin_users_request
      Admin::User.new(params[:environment], params[:page])
    end

    def api_key
      APPLICATION_ENVIRONMENT_VARIABLES[
        params[:environment]
      ]['HARVESTER_API_KEY']
    end

    def page
      params[:page] || 1
    end
  end
end
