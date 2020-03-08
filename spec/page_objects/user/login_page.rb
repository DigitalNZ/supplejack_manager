# frozen_string_literal: true

class LoginPage < ApplicationPage
  set_url 'users/sign_in'

  element :login_form, '#new_user'
  element :reset_password_link, :link, 'Forgot your password?'
end
