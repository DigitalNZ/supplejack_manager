# frozen_string_literal: true
# The majority of The Supplejack Manager code is Crown copyright (C) 2014,
# New Zealand Government,
# and is licensed under the GNU General Public License, version 3.
# Sme components are third party components that are licensed under
# the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ
# and the Department of Internal Affairs. http://digitalnz.org/supplejack

source 'https://rubygems.org'

gem 'rails', '~> 3.2.22.2'
# Need json and kgio to add after upgrade ruby 2.3.0
gem 'json', '1.8.3'
gem 'kgio', '~> 2.10.0'

gem 'supplejack_common', git: 'https://github.com/DigitalNZ/supplejack_common.git'
# Due to a bug in multibyte when using Ruby 2.x, we use the ref commit.
# We cannot get the HEAD oai this app is using Rails version 4.x
gem 'oai', git: 'https://github.com/code4lib/ruby-oai.git', ref: 'ebe92'
gem 'active_model_serializers', git: 'https://github.com/rails-api/active_model_serializers.git'
gem 'mongoid', '~> 3.1.7'
gem 'devise', '~> 3.0.4'
gem 'cancancan'
gem 'simple_form', git: 'https://github.com/plataformatec/simple_form.git'
gem 'figaro', '>= 0.7.0'
gem 'coderay', '~> 1.0.8'
gem 'honeybadger'
gem 'chronic_duration'
gem 'kaminari'
gem 'activeresource-response'
gem 'activeresource', require: 'active_resource'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'lograge'
gem 'airbrake', '~> 5.2'
gem 'test-unit'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails', '>= 1.0.3'
  gem 'zurb-foundation', '= 3.2.5'
  gem 'jquery-datatables-rails', git: 'https://github.com/rweng/jquery-datatables-rails.git'
end

group :development do
  gem 'quiet_assets', '>= 1.0.1'
  gem 'better_errors', '>= 0.2.0'
  gem 'binding_of_caller', '>= 0.6.8'
  gem 'guard-rspec'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'unicorn-rails'
  gem 'rubocop'
end

group :development, :test do
  gem 'pry-rails'
  gem 'faker'
  gem 'rspec-rails', '>= 2.12.2'
  gem 'factory_girl_rails', '>= 4.1.0'
end

group :test do
  gem 'simplecov', require: false
  gem 'database_cleaner', '>= 1.3.0'
  # gem 'email_spec', '>= 1.4.0'
  gem 'cucumber-rails', '>= 1.4.0', require: false
  gem 'launchy', '>= 2.1.2'
  gem 'capybara', '>= 2.0.1'
  gem 'timecop'
  gem 'webmock'
  gem 'vcr'
end
