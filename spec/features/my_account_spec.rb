describe 'my_account_page' do
  let(:email) { 'qwerty@gmail.co' }
  let(:password) { '1234567' }

  before(:all) do
    visit '/login'

    fill_in 'Email', with: ENV['USERNAME_SPREE']
    fill_in 'Password', with: ENV['PASSWORD_SPREE']

    find_button('Login').click
    find('a', text: 'My Account').click
  end

  after(:all) do
    fill_in 'Email', with: ENV['USERNAME_SPREE']
    fill_in 'Password', with: ENV['PASSWORD_SPREE']
    fill_in 'Password Confirmation', with: ENV['PASSWORD_SPREE']
    find_button('Update').click

    expect(page).to have_css('.alert-notice', text: 'Account updated')
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

      fill_in 'Email', with: email
      fill_in 'Password', with: ENV['PASSWORD_SPREE']
      fill_in 'Password Confirmation', with: ENV['PASSWORD_SPREE']

      find_button('Update').click

      expect(page).to have_css('.alert-notice', text: 'Account updated')
    end

    it 'can change password' do
      fill_in 'Email', with: email
      fill_in 'Password', with: ENV['PASSWORD_SPREE']

      find_button('Login').click
      find('a', text: 'Edit').click

      fill_in 'Password', with: password
      fill_in 'Password Confirmation', with: password

      find_button('Update').click

      expect(page).to have_css('.alert-notice', text: 'Account updated')
    end

    it 'cant change password' do
      fill_in 'Email', with: email
      fill_in 'Password', with: password

      find_button('Login').click
      find('a', text: 'Edit').click

      fill_in 'Password', with: ENV['PASSWORD_SPREE']
      fill_in 'Password Confirmation', with: password

      find_button('Update').click

      alert_text = find('.alert-danger').text
      expect(alert_text).to match "Password Confirmation doesn't match Password"
    end
  end
end