module MainHelper
  def fill_inputs(email, password, password_confirmation = nil)
    fill_in 'Email', with: email
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

  def create_user(email, password, password_confirmation)
    visit '/signup'
    fill_inputs(email, password, password_confirmation)
    click_button 'Create'
  end

  def logout
    find('a', text: 'Logout').click if page.has_css?('a', text: 'Logout')
  end
end