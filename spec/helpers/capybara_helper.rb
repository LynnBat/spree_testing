# frozen_string_literal: true

Capybara.configure do |config|
  include DriversHelper

  config.default_driver = ENV['BROWSER'].to_sym

  config.app_host = ENV['APP_HOST']

  config.save_path = 'logs/screenshots'

  if %w[ios android].include? ENV['BROWSER']
    # Default Appium server ip and port
    config.server_host = '0.0.0.0'
    config.server_port = '56844'
  end
end

ShowMeTheCookies.register_adapter(ENV['BROWSER'].to_sym, ShowMeTheCookies::Selenium)

Capybara::Screenshot.register_driver(ENV['BROWSER'].to_sym) do |driver, path|
  driver.browser.save_screenshot(path)
end
