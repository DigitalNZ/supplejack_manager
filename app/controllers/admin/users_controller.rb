# frozen_string_literal: true

module Admin
  # app/controllers/admin/users_controller.rb
  class UsersController < ApplicationController
    respond_to :csv, only: :index

    def index
      @users = Admin::User.new(params[:environment]).all
    end

    def edit
      @user = Admin::User.new(params[:environment]).find(params[:id])
    end

    def update
      if Admin::User.new(params[:environment]).update(user_params.to_hash)
        redirect_to environment_admin_users_path
      else
        render :edit
      end
    end

    private

    def user_params
      params.permit(:max_requests, :id)
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
