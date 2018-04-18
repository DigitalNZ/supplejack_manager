# frozen_string_literal: true

module Admin
  # app/controllers/admin/application_controller.rb
  class ApplicationController < ::ApplicationController
    before_action :authenticate_admin!

    def authenticate_admin!
      redirect_to root_path unless current_user.admin?
    end
  end
end
