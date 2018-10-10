describe 'login_page' do
  before { visit '/login' }

  context 'Visibility' do
    it 'has Email field' do
      expect(page).to have_css('input#spree_user_email')
    end

    it 'has Password field' do
      expect(page).to have_css('input#spree_user_password')
    end

    it 'has Remember_me checkbox' do
      expect(page).to have_css('input#spree_user_remember_me')
      expect(page).to have_css('label', text: 'Remember me')
    end
  end

  context 'Login process' do
    it 'can Log in as a User' do
      fill_in 'spree_user_email', with: ENV['USERNAME_SPREE']
      fill_in 'spree_user_password', with: ENV['PASSWORD_SPREE']
      find_button('Login').click
      expect(page).to have_css('a', text: 'Logout')
      expect(find('.alert-success').text).to eql 'Logged in successfully'
    end

    it 'cannot Log in as a User with incorrect email' do
      fill_in 'spree_user_email', with: '12345@qwe.co'
      fill_in 'spree_user_password', with: '12345'
      find_button('Login').click
      expect(find('.alert-error').text).to eql 'Invalid email or password.'
    end

    it 'cannot Log in as a User with incorrct password' do
      fill_in 'spree_user_email', with: ENV['USERNAME_SPREE']
      fill_in 'spree_user_password', with: '12345'
      find_button('Login').click
      expect(find('.alert-error').text).to eql 'Invalid email or password.'
    end

    it 'remembers User' do
      fill_in 'spree_user_email', with: ENV['USERNAME_SPREE']
      fill_in 'spree_user_password', with: ENV['PASSWORD_SPREE']
      check 'Remember me'
      find_button('Login').click
      expect(find('.alert-success').text).to eql 'Logged in successfully'
      expect(page).to have_css('a', text: 'Logout')
      expire_cookies
      refresh
      expect(page).not_to have_css('.alert-success', wait: false)
      expect(page).to have_css('a', text: 'Logout')
    end

    it 'doesnt remeber User' do
      fill_in 'spree_user_email', with: ENV['USERNAME_SPREE']
      fill_in 'spree_user_password', with: ENV['PASSWORD_SPREE']
      find_button('Login').click
      expect(find('.alert-success').text).to eql 'Logged in successfully'
      expect(page).to have_css('a', text: 'Logout')
      expire_cookies
      refresh
      expect(page).not_to have_css('.alert-success', wait: false)
      expect(page).not_to have_css('a', text: 'Logout')
    end
  end

  context 'Account creation' do
    it 'can Create New Account' do
      find('a', text: 'Create a new account').click
      fill_in 'spree_user_email', with: Faker::Internet.unique.email
      fill_in 'spree_user_password', with: 'asd567'
      fill_in 'spree_user_password_confirmation', with: 'asd567'
      find_button('Create').click
      expect(find('.alert-notice').text).to eql 'Welcome! You have signed up successfully.'
    end

    it 'cant create New Account with existing email' do
      find('a', text: 'Create a new account').click
      fill_in 'spree_user_email', with: ENV['USERNAME_SPREE']
      fill_in 'spree_user_password', with: ENV['PASSWORD_SPREE']
      fill_in 'spree_user_password_confirmation', with: ENV['PASSWORD_SPREE']
      find_button('Create').click
      expect(find('.alert-danger').text).to match 'Email has already been taken'
    end

    it 'cant create New Account with not matching passwords' do
      find('a', text: 'Create a new account').click
      fill_in 'spree_user_email', with: Faker::Internet.unique.email
      fill_in 'spree_user_password', with: 'asd567'
      fill_in 'spree_user_password_confirmation', with: 'qwerty'
      find_button('Create').click
      expect(find('.alert-danger').text).to match "Password Confirmation doesn't match Password"
    end
  end

  xit 'can Reset my Password'
end