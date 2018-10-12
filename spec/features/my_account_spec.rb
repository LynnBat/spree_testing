describe 'my_account_page' do
  let(:email) { 'qwerty@gmail.co' }
  let(:password) { '1234567' }
  before(:all) do
    visit '/login'
    fill_in 'spree_user_email', with: ENV['USERNAME_SPREE']
    fill_in 'spree_user_password', with: ENV['PASSWORD_SPREE']
    find_button('Login').click
    find('a', text: 'My Account').click
  end

  context 'displaying information' do
    it 'displays email' do
      expect(page).to have_css('dd', text: ENV['USERNAME_SPREE'])
    end

    it 'displays store credits' do
      expect(page).to have_css('dd', text: '$')
    end

    it 'displays orders' do
      expect(page).to have_css('.alert-info', text: 'You have no orders yet').or have_css('.order-number')
    end
  end

  context 'editing information' do
    it 'can change the email' do
      find('a', text: 'Edit').click

      fill_in 'user_email', with: email
      fill_in 'user_password', with: ENV['PASSWORD_SPREE']
      fill_in 'user_password_confirmation', with: ENV['PASSWORD_SPREE']

      find_button('Update').click

      expect(page).to have_css('.alert-notice', text: 'Account updated')
    end

    it 'can change password' do
      fill_in 'spree_user_email', with: email
      fill_in 'spree_user_password', with: ENV['PASSWORD_SPREE']

      find_button('Login').click
      find('a', text: 'Edit').click

      fill_in 'user_password', with: password
      fill_in 'user_password_confirmation', with: password

      find_button('Update').click

      expect(page).to have_css('.alert-notice', text: 'Account updated')
    end

    it 'cant change password' do
      fill_in 'spree_user_email', with: email
      fill_in 'spree_user_password', with: password

      find_button('Login').click
      find('a', text: 'Edit').click

      fill_in 'user_password', with: ENV['PASSWORD_SPREE']
      fill_in 'user_password_confirmation', with: password

      find_button('Update').click

      alert_text = find('.alert-danger').text
      expect(alert_text).to match "Password Confirmation doesn't match Password"
    end

    it 'restore email and password to default' do
      fill_in 'user_email', with: ENV['USERNAME_SPREE']
      fill_in 'user_password', with: ENV['PASSWORD_SPREE']
      fill_in 'user_password_confirmation', with: ENV['PASSWORD_SPREE']

      find_button('Update').click

      expect(page).to have_css('.alert-notice', text: 'Account updated')
    end
  end
end