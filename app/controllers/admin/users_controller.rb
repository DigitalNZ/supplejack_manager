# frozen_string_literal: true

module Admin
  # app/controllers/admin/users_controller.rb
  class UsersController < ApplicationController
    respond_to :csv, only: :index

    def index
      @admin_users = Admin::User.all
    end
  end
end
