
RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.infer_spec_type_from_file_location!
end
