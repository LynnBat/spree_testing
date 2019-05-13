# frozen_string_literal: true

Capybara.register_driver :safari do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :safari,
    driver_path: "#{Dir.pwd}/vendor/safaridriver"
  )
end
