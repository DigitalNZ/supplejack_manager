# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

source 'https://rubygems.org'

gem 'rails', '3.2.12'

gem 'supplejack_common', git: 'https://github.com/DigitalNZ/supplejack_common.git'
# Due to a bug in multibyte when using Ruby 2.x, we use the ref commit.
# We cannot get the HEAD oai this app is using Rails version 4.x
gem 'oai', git: 'https://github.com/code4lib/ruby-oai.git', ref: 'ebe92'
gem 'active_model_serializers', git: 'https://github.com/rails-api/active_model_serializers.git'
gem 'mongoid'
gem 'devise', '>= 2.1.2'
gem 'cancancan'
gem 'simple_form', git: 'https://github.com/plataformatec/simple_form.git'
gem 'figaro', '>= 0.5.0'
gem 'coderay', '~> 1.0.8'
gem 'honeybadger'
gem 'chronic_duration'
gem 'kaminari'
gem 'activeresource-response'
gem 'activeresource', require: 'active_resource'
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
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
  gem 'pry-rails'
  gem 'unicorn-rails'
end

group :development, :test do
  gem 'rspec-rails', '>= 2.12.2'
  gem 'factory_girl_rails', '>= 4.1.0'
end

group :test do
  gem 'simplecov', require: false
  gem 'database_cleaner', '>= 0.9.1'
  # gem 'email_spec', '>= 1.4.0'
  gem 'cucumber-rails', '>= 1.3.0', :require => false
  gem 'launchy', '>= 2.1.2'
  gem 'capybara', '>= 2.0.1'
  gem 'timecop'
  gem 'webmock'
  gem 'vcr'
end
