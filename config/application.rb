require_relative 'boot'

require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'
require 'action_cable/engine'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

APPLICATION_ENVS = YAML.load_file('config/application.yml').keys - ['development', 'test'] rescue []
APPLICATION_ENVIRONMENT_VARIABLES = YAML.load(ERB.new(File.read('config/application.yml')).result)

mfa = APPLICATION_ENVIRONMENT_VARIABLES[Rails.env]['MFA_ENABLED'] || ENV['MFA_ENABLED'] rescue false
MFA_ENABLED = ActiveModel::Type::Boolean.new.cast(mfa)

begin
  ENV.update YAML.load(ERB.new(File.read('config/application.yml')).result)[Rails.env]
rescue StandardError
  {}
end

module HarvesterManager
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths << "#{config.root}/app/models/concerns"

    config.time_zone = ENV['TIMEZONE']
  end
end
