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

  def env
    params[:environment]
  end

  def set_worker_environment_for(klass, environment = nil)
    env = environment || params[:environment] || APPLICATION_ENVS.first
    env_vars = fetch_env_vars(env)

    klass.site = env_vars['WORKER_HOST']
    klass.user = env_vars['WORKER_KEY']
  end

  def fetch_env_vars(environment)
    APPLICATION_ENVIRONMENT_VARIABLES[environment]
  end

  # :nodoc:
  module ClassMethods
    def change_worker_env!(env)
      self.site = APPLICATION_ENVIRONMENT_VARIABLES[env]['WORKER_HOST']
      self.user = APPLICATION_ENVIRONMENT_VARIABLES[env]['WORKER_KEY']
    end
  end
end
