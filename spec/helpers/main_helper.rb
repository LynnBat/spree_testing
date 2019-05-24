# frozen_string_literal: true

module MainHelper
  def wait_for(options = {})
    default_options = {
      error: nil,
      seconds: 7
    }.merge(options)

    Selenium::WebDriver::Wait.new(timeout: default_options[:seconds]).until { yield }
  rescue Selenium::WebDriver::Error::TimeOutError
    default_options[:error].nil? ? false : raise(default_options[:error])
  end

  def fill_inputs(email, password, password_confirmation = nil)
    user_email_id = page.has_css?('#spree_user_email') ? 'spree_user_email' : 'user_email'

    fill_in user_email_id, with: email
    fill_in 'Password', with: password
    fill_in 'Password Confirmation', with: password_confirmation if password_confirmation
  end

  def login(email, password)
    visit '/login'
    fill_inputs(email, password)
    click_button 'Login'
  end

  def admin_login
    login(ENV['ADMIN_SPREE'], ENV['ADMIN_PASSWORD_SPREE'])
  end

  def logout
    visit '/logout' if page.has_css?('a', text: 'Logout')
  end

  def create_new_user(user)
    visit '/signup'
    fill_inputs(user.email, user.password, user.password)
    click_button 'Create'
  end

  def credit_card
    {
      number: '4111111111111111',
      expiry_date: '05/25',
      cvv: '2946'
    }
  end

  def credit_card2
    {
      number: '4222222222222222',
      expiry_date: '07/30',
      cvv: '2946'
    }
  end
end
