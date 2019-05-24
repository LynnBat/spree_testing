# frozen_string_literal: true

RSpec.feature 'login_page' do
  let(:user)   { User.new }
  let(:router) { Router.new }

  before { visit router.login_path }

  scenario 'has all blocks' do
    aggregate_failures do
      expect(page).to have_css('.panel-heading', text: 'Login as Existing Customer')
      expect(page).to have_css('input#spree_user_email')
      expect(page).to have_css('input#spree_user_password')
      expect(page).to have_css('#spree_user_remember_me')
      expect(page).to have_css('.btn-success[data-disable-with="Login"]')
      expect(page).to have_css('a', text: 'Create a new account')
      expect(page).to have_css('a', text: 'Forgot Password?')

      find('a', text: 'Forgot Password?').click
      expect(page).to have_css('p', text: 'Please enter your email on the form below')
    end
  end

  scenario "can't restore the password" do
    find('a', text: 'Forgot Password?').click

    click_on 'Reset my password'
    expect(page).to have_css('.alert-danger', text: "Email can't be blank")
  end

  # skipped because it's the bug
  xscenario 'can restore the password' do
    find('a', text: 'Forgot Password?').click

    fill_in 'spree_user_email', with: ENV['USERNAME_SPREE']
    click_on 'Reset my password'

    expect(page).to have_content 'Password reset email sent'
  end

  describe 'Login' do
    context 'Successful' do
      before { fill_inputs(ENV['USERNAME_SPREE'], ENV['PASSWORD_SPREE']) }

      scenario 'can Log in as a User' do
        click_button 'Login'

        aggregate_failures do
          expect(page).to have_css('a', text: 'Logout')
          expect(page).to have_css('.alert-success', text: 'Logged in successfully')
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

    context 'Unsuccessful' do
      scenario 'with incorrect email' do
        fill_inputs(user.email, user.password)
        click_button 'Login'

        expect(page).to have_css('.alert-error', text: 'Invalid email or password.')
      end

      scenario 'with incorrect password' do
        fill_inputs(ENV['USERNAME_SPREE'], user.password)
        click_button 'Login'

        expect(page).to have_css('.alert-error', text: 'Invalid email or password.')
      end
    end
  end

  describe 'Account creation' do
    before { find('a', text: 'Create a new account').click }

    scenario 'can Create New Account' do
      fill_inputs(user.email, user.password, user.password)
      click_button 'Create'

      expect(page).to have_css('.alert-notice', text: 'Welcome! You have signed up successfully.')
    end

    scenario "can't create New Account with existing email" do
      fill_inputs(ENV['USERNAME_SPREE'], user.password, user.password)
      click_button 'Create'

      expect(page).to have_css('.alert-danger', text: 'Email has already been taken')
    end

    scenario 'cant create New Account with not matching passwords' do
      fill_inputs(user.email, user.password, ENV['PASSWORD_SPREE'])
      click_button 'Create'

      expect(page).to have_css('.alert-danger', text: "Password Confirmation doesn't match Password")
    end
  end
end
