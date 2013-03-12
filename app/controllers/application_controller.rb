class ApplicationController < ActionController::Base
  protect_from_forgery

  include WorkerEnvironmentHelpers

  before_filter :authenticate_user!

  def set_worker_environment_for(klass)
    if Rails.env.development?
      environment = "development"
    elsif params[:environment] == "test"
      environment = "staging"
    else
      environment = params[:environment]
    end

    env_vars = Figaro.env(environment)
    klass.site = env_vars["WORKER_HOST"]
    klass.user = env_vars["WORKER_API_KEY"]
  end
end