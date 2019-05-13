# frozen_string_literal: true

desired_caps_ios = {
  'platformName': 'iOS',
  'platformVersion': '12.1',
  'browserName': 'Safari',
  'automationName': 'XCUITest',
  'startIWDP': true,
  'udid': 'auto',
  'deviceName': 'iPhone 7 Plus'
}

url = 'http://localhost:4723/wd/hub'

Capybara.register_driver(:ios) do |app|
  appium_lib_options = {
    server_url: url
  }

  all_options = {
    appium_lib: appium_lib_options,
    caps: desired_caps_ios
  }

  Appium::Capybara::Driver.new app, all_options
end
