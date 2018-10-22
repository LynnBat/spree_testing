require 'bundler'
Bundler.require
require 'capybara/dsl'
require 'rspec/expectations'
require 'faker'
require 'show_me_the_cookies'

# Adding helpers to all Specs
Dir['./spec/helpers/**/*.rb'].each { |file| require file }
Dir['./spec/shared_examples/**/*.rb'].each { |file| require file }

# New driver for Chrome browser
Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

# New driver for Firefox browser
Capybara.register_driver :firefox do |app|
  Capybara::Selenium::Driver.new(app, browser: :firefox)
end

Capybara.register_driver :safari do |app|
  Capybara::Selenium::Driver.new(app, browser: :safari)
end

# Default settings for project
# - don't use rails server
# - Use Safari as default
# - Set up staging environment as default
ENV['browser'] ||= 'chrome'
Capybara.default_driver = case ENV['browser']
                          when 'chrome'
                            :chrome
                          when 'firefox'
                            :firefox
                          when 'safari'
                            :safari
                          end 

ShowMeTheCookies.register_adapter(ENV['browser'].to_sym, ShowMeTheCookies::Selenium)

Capybara.app_host = 'https://spree-qa-lynn.herokuapp.com'

Capybara.run_server = false
Capybara.page.driver.browser.manage.window.maximize

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include MainHelper
  config.include LinksHelper
  config.include ShowMeTheCookies

  config.after do
    Capybara.reset_sessions!
  end
  
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end 

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end 

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
