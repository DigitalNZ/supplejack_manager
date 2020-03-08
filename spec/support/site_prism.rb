# frozen_string_literal: true

# Require page objects
require './spec/page_objects/application_page.rb'
Dir[Rails.root.join('spec', 'page_objects', '**', '*.rb')].each { |f| require f }
