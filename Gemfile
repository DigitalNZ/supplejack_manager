# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}" }

gem 'active_model_serializers', '~> 0.10.0'
gem 'activeresource', require: 'active_resource'
gem 'activeresource-response'
gem 'aws-sdk-s3'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'cancancan'
gem 'coderay', '~> 1.1.2'
gem 'devise', '~> 4.0'
gem 'kaminari'
gem 'kaminari-mongoid'
gem 'mongoid'
gem 'mongoid_paranoia'
gem 'oai'
gem 'puma'
gem 'rails', '~> 6.0'
gem 'server_timing'
gem 'supplejack_common', github: 'DigitalNZ/supplejack_common', tag: 'v2.9.0'

# assets gems
gem 'webpacker'

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
  gem 'rubocop', require: false
  gem 'rubocop-rails_config', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-performance', require: false
end

group :uat, :staging, :production do
  gem 'airbrake'
  gem 'lograge'
  gem 'ougai'
end
