# frozen_string_literal: true

# app/models/concerns/environment_helpers.rb
module EnvironmentHelpers
  extend ActiveSupport::Concern

  ['harvest_job', 'harvest_schedule'].each do |model|
    define_method("#{model.pluralize}_path") do |*args|
      env = params[:environment] || 'staging'
      send("environment_#{model.pluralize}_path", env, args[0])
    end

    define_method("#{model}_path") do |*args|
      env = params[:environment] || 'staging'
      send("environment_#{model}_path", env, args[0])
    end
  end


  def set_worker_environment_for(klass, environment = nil)
    if environment.present?
      env_vars = APPLICATION_ENVIRONMENT_VARIABLES[environment]
    else
      env_vars = fetch_env_vars
    end

    klass.site = env_vars['WORKER_HOST']
    klass.user = env_vars['WORKER_KEY']
  end


  def fetch_env_vars(environment = nil)
    if Rails.env.development? && params[:environment]
      environment = params[:environment]
    elsif Rails.env.development?
      environment = 'development'
    elsif params[:environment] == 'test'
      environment = 'staging'
    else
      environment = params[:environment] || params[:env]
    end

    APPLICATION_ENVIRONMENT_VARIABLES[environment]
  end

  # :nodoc:
  module ClassMethods
    def change_worker_env!(env)
      env_hash = APPLICATION_ENVIRONMENT_VARIABLES[env]
      self.site = env_hash['WORKER_HOST']
      self.user = env_hash['WORKER_KEY']
    end
  end
end
