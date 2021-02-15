# frozen_string_literal: true

# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action do
    ServerTiming::Auth.ok!
  end

  protect_from_forgery with: :exception

  include EnvironmentHelpers

  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, alert: exception.message
  end

  def safe_users_path(params = {})
    current_user.admin? ? users_path(params) : root_path
  end

  def authenticate_user!
    return super unless valid_token?

    authenticate_or_request_with_http_token do |token, _options|
      # Compare the tokens in a time-constant manner, to mitigate
      # timing attacks.
      ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(token),
        ::Digest::SHA256.hexdigest(ENV['WORKER_KEY'])
      )
    end
  end

  def valid_token?
    request.headers['Authorization'].present? && request.headers['Authorization'].include?('Token token')
  end

  protected
    def configure_permitted_parameters
      return unless MFA_ENABLED
      
      devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
    end
end
