# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include ActionController::HttpAuthentication::Token::ControllerMethods

  protect_from_forgery

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
end
