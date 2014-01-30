class ApplicationController < ActionController::Base
  protect_from_forgery

  include WorkerEnvironmentHelpers

  before_filter :authenticate_user!

  def set_worker_environment_for(klass, environment=nil)
    env_vars = fetch_env_vars(environment)
    klass.site = env_vars["WORKER_HOST"]
    klass.user = env_vars["WORKER_API_KEY"]
  end

  def fetch_env_vars(environment=nil)

    if environment.present?
      environment = environment
    elsif Rails.env.development? && params[:environment]
      environment = params[:environment]
    elsif Rails.env.development? 
      environment = "development"
    elsif params[:environment] == "test"
      environment = "staging"
    else
      environment = params[:environment]
    end

    return Figaro.env(environment)
  end
end