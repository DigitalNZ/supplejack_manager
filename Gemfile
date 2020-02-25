# frozen_string_literal: true

source 'https://rubygems.org'

gem 'active_model_serializers', '~> 0.10.0'
gem 'activeresource', require: 'active_resource'
gem 'activeresource-response'
gem 'aws-sdk-s3'
gem 'cancancan'
gem 'coderay', '~> 1.0.8'
gem 'devise', '~> 4.0'
gem 'elastic-apm'
gem 'figaro', '>= 0.7.0'
gem 'json', '1.8.3'
gem 'kaminari'
gem 'kaminari-mongoid'
gem 'kgio', '~> 2.10.0'
gem 'mongoid'
gem 'mongoid_paranoia'
gem 'moped'
gem 'nokogiri'
gem 'oai', git: 'https://github.com/code4lib/ruby-oai.git', ref: 'ebe92'
gem 'puma'
gem 'rails', '~> 5.1'
gem 'server_timing'
gem 'simple_form', git: 'https://github.com/plataformatec/simple_form.git'
gem 'supplejack_common', git: 'https://github.com/DigitalNZ/supplejack_common.git', tag: 'v2.7.1'

# assets gems
gem 'compass-rails', '>= 1.0.3'
gem 'foundation-rails'
gem 'jquery-datatables-rails', git: 'https://github.com/rweng/jquery-datatables-rails.git'
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
  gem 'lograge'
  gem 'ougai'
end
