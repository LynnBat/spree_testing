# frozen_string_literal: true

RSpec.feature 'login_page' do
  let(:user)   { User.new }
  let(:router) { Router.new }

  before { visit router.login_path }

  scenario 'has Email, Password, Remember me inputs' do
    aggregate_failures do
      expect(page).to have_css('input#spree_user_email')
      expect(page).to have_css('input#spree_user_password')
      expect(page).to have_css('input#spree_user_remember_me')
      expect(page).to have_css('label', text: 'Remember me')
    end
  end

  xscenario 'restore password' do
    find('a', text: 'Forgot Password?').click

    expect(page).to have_css('p', text: 'Please enter your email on the form below')

    fill_in 'spree_user_email', with: ENV['USERNAME_SPREE']
    click_button('Reset my password')

    # this is a bug, i'll write expected line later
  end

  describe 'Login process' do
    context 'Login successful' do
      before { fill_inputs(ENV['USERNAME_SPREE'], ENV['PASSWORD_SPREE']) }

      scenario 'can Log in as a User' do
        click_button 'Login'

        alert_text = find('.alert-success').text

        aggregate_failures do
          expect(page).to have_css('a', text: 'Logout')
          expect(alert_text).to eq 'Logged in successfully'
        end
      end

      scenario 'remembers User' do
        check 'Remember me'
        click_button 'Login'

        expire_cookies
        refresh

        aggregate_failures do
          expect(page).not_to have_css('.alert-success', wait: false)
          expect(page).to have_css('a', text: 'Logout')
        end
      end

      scenario "doesn't remeber User" do
        click_button 'Login'

        expire_cookies
        refresh

        aggregate_failures do
          expect(page).not_to have_css('.alert-success', wait: false)
          expect(page).not_to have_css('a', text: 'Logout')
        end
      end
    end

    context 'Login unsuccessful' do
      scenario 'cannot Log in as a User with incorrect email' do
        fill_inputs(user.email, user.password)

        click_button 'Login'

        alert_text = find('.alert-error').text
        expect(alert_text).to eq 'Invalid email or password.'
      end

      scenario 'cannot Log in as a User with incorrect password' do
        fill_inputs(ENV['USERNAME_SPREE'], user.password)

        click_button 'Login'

        alert_text = find('.alert-error').text
        expect(alert_text).to eq 'Invalid email or password.'
      end
    end
  end

  describe 'Account creation' do
    before { find('a', text: 'Create a new account').click }

    scenario 'can Create New Account' do
      fill_inputs(user.email, user.password, user.password)

      click_button 'Create'

      alert_text = find('.alert-notice').text
      expect(alert_text).to eq 'Welcome! You have signed up successfully.'
    end

    scenario "can't create New Account with existing email" do
      fill_inputs(ENV['USERNAME_SPREE'], user.password, user.password)

      click_button 'Create'

      alert_text = find('.alert-danger').text
      expect(alert_text).to match 'Email has already been taken'
    end

    scenario 'cant create New Account with not matching passwords' do
      fill_inputs(user.email, user.password, ENV['PASSWORD_SPREE'])

      click_button 'Create'

      alert_text = find('.alert-danger').text
      expect(alert_text).to match "Password Confirmation doesn't match Password"
    end
  end
end
