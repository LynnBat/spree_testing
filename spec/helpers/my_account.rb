module MyAccountHelper
  def fill_inputs(email, password, password_confirmation = nil)
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password Confirmation', with: password_confirmation if s_password_confirmation
  end

  def login(email, password)
    visit '/login'
    fill_inputs(email, password)
    click_button 'Login'
  end

  def logout
    find('a', text: 'Logout').click
  end
end