# frozen_string_literal: true

class ForgotPasswordPage < ApplicationPage
  set_url 'users/password/new'

  element :reset_password_form, '#new_user'
end
