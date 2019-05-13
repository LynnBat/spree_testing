# frozen_string_literal: true

Capybara.register_driver :chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      args: [
        ('headless' if ENV.fetch('HEADLESS', '1') == '1')
      ].compact
    }
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    driver_path: path_to_driver('chromedriver'),
    desired_capabilities: capabilities
  )
end
