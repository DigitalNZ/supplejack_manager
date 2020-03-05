# frozen_string_literal: true

require 'capybara'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'selenium/webdriver'
require 'webdrivers'

CAPYBARA_WINDOW_DEFAULTS = [1440, 900]

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
  options = Selenium::WebDriver::Chrome::Options.new(args: [
    'headless',
    'disable-gpu',
    'no-sandbox',
    'disable-dev-shm-usage',
    "window-size=#{CAPYBARA_WINDOW_DEFAULTS.join(',')}"
  ])
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = :headless_chrome
