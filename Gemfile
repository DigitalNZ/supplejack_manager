
source 'https://rubygems.org'

gem 'rails', '~> 5.1'
# Need json and kgio to add after upgrade ruby 2.3.0
gem 'json', '1.8.3'
gem 'kgio', '~> 2.10.0'

gem 'supplejack_common', git: 'https://github.com/DigitalNZ/supplejack_common.git', tag: 'v2.6'

# Due to a bug in multibyte when using Ruby 2.x, we use the ref commit.
# We cannot get the HEAD oai this app is using Rails version 4.x

gem 'responders', '~> 2.0'
gem 'oai', git: 'https://github.com/code4lib/ruby-oai.git', ref: 'ebe92'
gem 'active_model_serializers', '~> 0.10.0'
gem 'mongoid'
gem 'mongoid_paranoia'
gem 'devise', '~> 4.0'
gem 'cancancan'
gem 'simple_form', git: 'https://github.com/plataformatec/simple_form.git'
gem 'figaro', '>= 0.7.0'
gem 'coderay', '~> 1.0.8'
gem 'chronic_duration'
gem 'kaminari'
gem 'kaminari-mongoid'
gem 'activeresource-response'
gem 'activeresource', require: 'active_resource'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-timepicker-rails'
gem 'lograge'
gem 'airbrake'
gem 'test-unit'
gem 'nokogiri'
gem 'moped'
gem 'bson'
gem 'modernizr-rails'
gem 'rails-controller-testing'
gem 'sass-rails'
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
gem 'uglifier', '>= 1.0.3'
gem 'compass-rails', '>= 1.0.3'
gem 'foundation-rails'
gem 'jquery-datatables-rails', git: 'https://github.com/rweng/jquery-datatables-rails.git'
gem 'activeresource-response'
gem 'puma'
gem 'server_timing'
gem 'aws-sdk-s3'
gem 'elastic-apm'

group :development do
  gem 'binding_of_caller', '>= 0.6.8'
  gem 'guard-rspec'
  gem 'rb-fsevent'
  gem 'unicorn-rails'
  gem 'rubocop', require: false
  gem 'web-console'
end

group :development, :test do
  gem 'pry-byebug'
  gem 'faker'
  gem 'rspec-rails', '>= 3.7.2'
  gem 'factory_bot_rails'
end

group :test do
  gem 'capybara', '>= 2.17.0'
  gem 'capybara-screenshot'
  gem 'capybara-selenium'
  gem 'chromedriver-helper'
  gem 'database_cleaner', '>= 1.3.0'
  gem 'launchy', '>= 2.1.2'
  gem 'simplecov', require: false
  gem 'site_prism'
  gem 'timecop'
  gem 'vcr'
  gem 'webmock'
end
