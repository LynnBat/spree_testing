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

  # fill_inputs part should be re-written
  def add_stock (product_link, quantity)
    visit product_link
    fill_inputs('spree@example.com', 'spree123')
    click_button 'Login'
    fill_in 'stock_movement_quantity', with: quantity
    click_button 'Add Stock'
  end
end