# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}" }

gem 'active_model_serializers', '~> 0.10.0'
gem 'activeresource', require: 'active_resource'
gem 'activeresource-response'
gem 'aws-sdk-s3'
gem 'cancancan'
gem 'coderay', '~> 1.0.8'
gem 'devise', '~> 4.0'
gem 'kaminari'
gem 'kaminari-mongoid'
gem 'mongoid'
gem 'mongoid_paranoia'
gem 'oai'
gem 'puma'
gem 'rails', '~> 5.2'
gem 'server_timing'
gem 'supplejack_common', github: 'DigitalNZ/supplejack_common', tag: 'v2.7.1'

# assets gems
gem 'compass-rails', '>= 1.0.3'
gem 'foundation-rails', '~> 6.4.1'
gem 'jquery-datatables-rails'
gem 'jquery-rails'
gem 'jquery-timepicker-rails'
gem 'jquery-ui-rails'
gem 'modernizr-rails'
gem 'sass-rails'
gem 'therubyracer', platforms: :ruby
gem 'uglifier', '>= 1.0.3'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'guard-rspec'
  gem 'rb-fsevent'
  gem 'unicorn-rails'
  gem 'web-console'
end

group :development, :test do
  gem 'pry-byebug'
  gem 'rubocop', require: false
end

group :test do
  gem 'capybara', '>= 2.17.0'
  gem 'capybara-screenshot'
  gem 'capybara-selenium'
  gem 'database_cleaner', '>= 1.3.0'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'launchy', '>= 2.1.2'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '>= 3.7.2'
  gem 'simplecov', require: false
  gem 'site_prism'
  gem 'test-unit'
  gem 'timecop'
  gem 'vcr'
  gem 'webdrivers', '= 3.7.2'
  gem 'webmock'
end

group :uat, :staging, :production do
  gem 'airbrake'
  gem 'elastic-apm'
  gem 'lograge'
  gem 'ougai'
end
