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
gem 'mimemagic', '= 0.3.10'
gem 'mongoid'
gem 'mongoid_paranoia'
gem 'oai'
gem 'puma', '~> 4.3.11'
gem 'rails', '~> 6.1.4.4'
gem 'redis', '~> 4.0' # for action_cable in production
gem 'render_async', '~> 2.1', '>= 2.1.11'
gem 'rqrcode'
gem 'rubocop', require: false
gem 'server_timing'
gem 'supplejack_common', github: 'DigitalNZ/supplejack_common', tag: 'v2.10.5'
gem 'two_factor_authentication'

# assets gems
gem 'webpacker'

# AWS gems required by parsers
gem 'aws-sdk-s3'
gem 'aws-sdk-rekognition', '~> 1.59'

group :test do
  gem 'capybara', '>= 2.17.0'
  gem 'capybara-screenshot'
  gem 'database_cleaner-mongoid', '>= 1.3.0'
  gem 'factory_bot_rails', '~> 5.0'
  gem 'faker'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '>= 3.7.2'
  gem 'simplecov', require: false
  gem 'site_prism'
  gem 'timecop'
  gem 'webdrivers'
end

group :development do
  gem 'unicorn-rails'

  # better error
  gem 'better_errors'
  gem 'binding_of_caller'

  # spring
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring', '~> 2.1'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  # debuggers
  gem 'pry-byebug'
  gem 'pry-rails'

  # rubocop tests
  gem 'rubocop-rails_config', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-performance', require: false
end

group :production do
  gem 'elastic-apm'
end

group :uat, :staging, :production do
  gem 'lograge'
  gem 'ougai'
end
