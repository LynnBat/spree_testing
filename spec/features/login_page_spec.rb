describe 'login_page' do
  before { visit '/login' }

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

  it 'can Log in as a User' do
    fill_in 'spree_user_email', with: ENV['USERNAME_SPREE']
    fill_in 'spree_user_password', with: ENV['PASSWORD_SPREE']
    find_button('Login').click
    expect(page).to have_css('a', text: 'Logout')
  end

  it 'cannot Log in as a User' do
    fill_in 'spree_user_email', with: '12345@qwe.co'
    fill_in 'spree_user_password', with: '12345'
    find_button('Login').click
    expect(find('.alert-error').text).to eql 'Invalid email or password.'
  end

  xit 'remembers User'
  xit 'doesnt remeber User'
  xit 'can Create New Account'
  xit 'cant create New Account with existing email'
  xit 'can Reset my Password'
end