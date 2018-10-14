module MyAccountHelper
  def login(s_email, s_password)
    fill_in 'Email', with: s_email
    fill_in 'Password', with: s_password

    find_button('Login').click
    find('a', text: 'My Account').click
  end

  def logout
    find('a', text: 'Logout').click
  end
end