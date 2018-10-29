describe 'login_page' do
  let(:password) { '1234567' }
  before { visit '/login' }

  it 'has Email, Password, Remember me inputs' do
    aggregate_failures do
      expect(page).to have_css('input#spree_user_email')
      expect(page).to have_css('input#spree_user_password')
      expect(page).to have_css('input#spree_user_remember_me')
      expect(page).to have_css('label', text: 'Remember me')
    end
  end

  xit 'restore password' do
    find('a', text: 'Forgot Password?').click

    expect(page).to have_css('p', text: 'Please enter your email on the form below')

    fill_in 'spree_user_email', with: ENV['USERNAME_SPREE']
    click_button('Reset my password')

    # this is a bug, i'll write expected line later
  end

  describe 'Login process' do
    context 'Login successful' do
      before do
        fill_in 'spree_user_email', with: ENV['USERNAME_SPREE']
        fill_in 'spree_user_password', with: ENV['PASSWORD_SPREE']
      end

      it 'can Log in as a User' do
        find_button('Login').click

        expect(page).to have_css('a', text: 'Logout')
        alert_text = find('.alert-success').text
        expect(alert_text).to eq 'Logged in successfully'
      end

      it 'remembers User' do
        check 'Remember me'
        find_button('Login').click

        alert_text = find('.alert-success').text
        expect(alert_text).to eq 'Logged in successfully'
        expect(page).to have_css('a', text: 'Logout')

        expire_cookies
        refresh

        expect(page).not_to have_css('.alert-success', wait: false)
        expect(page).to have_css('a', text: 'Logout')
      end

      it 'doesnt remeber User' do
        find_button('Login').click

        alert_text = find('.alert-success').text
        expect(alert_text).to eq 'Logged in successfully'
        expect(page).to have_css('a', text: 'Logout')

        expire_cookies
        refresh

        expect(page).not_to have_css('.alert-success', wait: false)
        expect(page).not_to have_css('a', text: 'Logout')
      end
    end

    context 'Login unsuccessful' do
      it 'cannot Log in as a User with incorrect email' do
        fill_in 'spree_user_email', with: '12345@qwe.co'
        fill_in 'spree_user_password', with: password

        find_button('Login').click

        alert_text = find('.alert-error').text
        expect(alert_text).to eq 'Invalid email or password.'
      end

      it 'cannot Log in as a User with incorrct password' do
        fill_in 'spree_user_email', with: ENV['USERNAME_SPREE']
        fill_in 'spree_user_password', with: password

        find_button('Login').click

        alert_text = find('.alert-error').text
        expect(alert_text).to eq 'Invalid email or password.'
      end
    end
  end

  context 'Account creation' do
    before { find('a', text: 'Create a new account').click }

    it 'can Create New Account' do
      fill_in 'spree_user_email', with: Faker::Internet.unique.email
      fill_in 'spree_user_password', with: password
      fill_in 'spree_user_password_confirmation', with: password

      find_button('Create').click

      alert_text = find('.alert-notice').text
      expect(alert_text).to eq 'Welcome! You have signed up successfully.'
    end

    it 'cant create New Account with existing email' do
      fill_in 'spree_user_email', with: ENV['USERNAME_SPREE']
      fill_in 'spree_user_password', with: ENV['PASSWORD_SPREE']
      fill_in 'spree_user_password_confirmation', with: ENV['PASSWORD_SPREE']

      find_button('Create').click

      alert_text = find('.alert-danger').text
      expect(alert_text).to match 'Email has already been taken'
    end

    it 'cant create New Account with not matching passwords' do
      fill_in 'spree_user_email', with: Faker::Internet.unique.email
      fill_in 'spree_user_password', with: password
      fill_in 'spree_user_password_confirmation', with: ENV['PASSWORD_SPREE']

      find_button('Create').click

      alert_text = find('.alert-danger').text
      expect(alert_text).to match "Password Confirmation doesn't match Password"
    end
  end
end