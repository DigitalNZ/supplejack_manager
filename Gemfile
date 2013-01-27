source 'https://rubygems.org'

gem 'rails',        '3.2.11'

gem "harvester_core", git: "git@scm.digitalnz.org:harvester/core"
# gem "harvester_core", path: "/Users/fede/code/hippo/harvester/core"

gem "oai", git: "https://github.com/code4lib/ruby-oai.git"

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem "thin",         ">= 1.5.0"
gem "mongoid",      "~> 3.0.19"

gem "devise",       ">= 2.1.2"
gem "simple_form",  git: "https://github.com/plataformatec/simple_form.git"
gem "figaro",       ">= 0.5.0"
gem "grit"
gem "coderay",      "~> 1.0.8"
gem "airbrake"

gem "sidekiq"
gem 'slim'
# if you require 'sinatra' you get the DSL extended to Object
gem 'sinatra', :require => nil

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',       '~> 3.2.3'
  gem 'coffee-rails',     '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier',         '>= 1.0.3'

  gem "compass-rails",    ">= 1.0.3"
  gem "zurb-foundation",  ">= 3.2.3"
end

gem 'jquery-rails'

group :development do
  gem "quiet_assets",       ">= 1.0.1"
  gem "better_errors",      ">= 0.2.0"
  gem "binding_of_caller",  ">= 0.6.8"
  gem 'guard-rspec'
  gem 'rb-fsevent',         '~> 0.9.1'
  gem 'zeus'
end

group :development, :test do
  gem "rspec-rails",        ">= 2.12.2"
  gem "factory_girl_rails", ">= 4.1.0"
end

group :test do
  gem "database_cleaner",   ">= 0.9.1"
  # gem "email_spec",         ">= 1.4.0"
  gem "cucumber-rails",     ">= 1.3.0", :require => false
  gem "launchy",            ">= 2.1.2"
  gem "capybara",           ">= 2.0.1"
  gem 'timecop'
end
