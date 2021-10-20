# frozen_string_literal: true

class TwoFactorAuthenticationSettingsController < ApplicationController
  def create
    return unless MFA_ENABLED

    user = User.find(mfa_params[:user_id])

    unless user.authenticate_totp(mfa_params[:otp])
      redirect_to(
        edit_user_path(user),
        alert: 'Incorrect two factor authentication code'
      ) && return
    end

    redirect_to(
      edit_user_path(user),
      notice: 'Successfully enabled two factor authentication'
    )
  end

  private
    def mfa_params
      params.require(:two_factor_authentication_settings).permit(:otp, :user_id)
    end
end
