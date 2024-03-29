# frozen_string_literal: true

# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  before_action :confirm_two_factor_authenticated, except: [:new, :create, :cancel]

  protected
    def confirm_two_factor_authenticated
      return unless User.new.need_two_factor_authentication?
      return if is_fully_authenticated?

      flash[:error] = t('devise.errors.messages.user_not_authenticated')
      redirect_to user_two_factor_authentication_url
    end
end
