# frozen_string_literal: true

module Admin
  # app/controllers/admin/users_controller.rb
  class UsersController < ApplicationController
    respond_to :csv, only: :index

    def index
      @admin_users = Admin::User.all
    end

    def edit
      @admin_user = Admin::User.find(params[:id])
    end

    def update
      @admin_user = Admin::User.find(params[:id])

      if @admin_user.update_attributes(user_params)
        redirect_to admin_users_path
      else
        render :edit
      end
    end

    private

    def user_params
      params.require(:admin_user).permit(:max_requests)
    end
  end
end
