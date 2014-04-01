class ApplicationController < ActionController::Base
  protect_from_forgery

  include EnvironmentHelpers

  before_filter :authenticate_user!
end