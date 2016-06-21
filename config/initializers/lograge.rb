HarvesterManager::Application.configure do
  config.lograge.enabled = true
  # show the params in lograge.
  config.lograge.custom_options = lambda do |event|
    exceptions = %w(controller action format id)
    {
      params: event.payload[:params].except(*exceptions)
    }
  end
end
