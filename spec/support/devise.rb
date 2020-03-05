# frozen_string_literal: true

require 'devise'

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers

  config.after :each do
    Warden.test_reset!
  end
end
