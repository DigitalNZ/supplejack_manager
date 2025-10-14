# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}" }

gem 'active_model_serializers', '~> 0.10.0'
gem 'activeresource', require: 'active_resource'
gem 'activeresource-response'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'cancancan'
gem 'devise', '~> 4.0'
gem 'erb_lint', require: false
gem 'kaminari'
gem 'kaminari-mongoid'
gem 'mini_portile2'
gem 'mongoid'
gem 'mongoid_paranoia'
gem 'oai'
gem 'puma'
gem 'rails', '~> 7.2.2.2'
gem 'redis', '~> 4.0' # for action_cable in production
gem 'rqrcode'
gem 'server_timing'
gem 'supplejack_common', github: 'DigitalNZ/supplejack_common', tag: 'v3.0.3'
gem 'two_factor_authentication'

# Logging
gem 'lograge'
gem 'ougai'

# Hotwire and turbo
gem 'turbo-rails'
gem 'stimulus-rails'

# assets gems
gem 'sprockets-rails'
gem 'jsbundling-rails'
gem 'cssbundling-rails'

# AWS gems required by parsers
gem 'aws-sdk-s3'
gem 'aws-sdk-rekognition', '~> 1.59'

# error reporting
gem 'elastic-apm'

group :test do
  gem 'capybara', '>= 2.17.0'
  gem 'capybara-screenshot'
  gem 'database_cleaner-mongoid', '>= 1.3.0'
  gem 'factory_bot_rails', '~> 6.0'
  gem 'faker'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '>= 3.7.2'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'site_prism'
  gem 'timecop'
end

group :development do
  # better error
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'

  # provides bin/codeclimate_diff
  gem 'codeclimate_diff', github: 'boost/codeclimate_diff'

  # rubocop tests
  gem 'rubocop', require: false
  gem 'rubocop-rails_config', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-performance', require: false
end
