# frozen_string_literal: true

class TwoFactorAuthenticationSettingsController < ApplicationController
  def create
    unless current_user.validate_and_consume_otp!(params.dig(:two_factor_authentication_settings, :otp))
      redirect_to(
        edit_user_path(current_user),
        alert: 'Incorrect two factor authentication code'
      ) && return
    end

    redirect_to(
      edit_user_path(current_user),
      notice: 'Successfully enabled two factor authentication'
    )
  end
end
