# frozen_string_literal: true

require 'capybara'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'selenium/webdriver'
require 'webdrivers'

CAPYBARA_WINDOW_DEFAULTS = [1440, 900]

if ENV['SELENIUM_URI'].present?
  net = Socket.ip_address_list.find(&:ipv4_private?)
  Capybara.server_port = 8200
  Capybara.server_host = net.nil? ? 'localhost' : net.ip_address
end

# Capybara Screenshot
Capybara::Screenshot.webkit_options = { width: CAPYBARA_WINDOW_DEFAULTS[0], height: CAPYBARA_WINDOW_DEFAULTS[1] }
Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
  "screenshot_#{example.description.tr(' ', '-').gsub(%r{^.*\/spec\/}, '')}"
end
Capybara::Screenshot.prune_strategy = :keep_last_run
Capybara::Screenshot.register_driver(:headless_chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end


Capybara.register_driver :headless_chrome do |app|
  args = [
    'headless',
    'disable-gpu',
    'no-sandbox',
    'disable-dev-shm-usage',
    'window-size=1400,1400'
  ]

  if ENV['SELENIUM_URI'].present?
    uri = URI(ENV['SELENIUM_URI'])

    Capybara::Selenium::Driver.new(
      app,
      browser: :remote,
      url: "http://#{uri.host}:#{uri.port}/wd/hub/",
      desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: { args: args }
      )
    )
  else
    options = Selenium::WebDriver::Chrome::Options.new(args: args)
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end
end

Capybara.javascript_driver = :headless_chrome
