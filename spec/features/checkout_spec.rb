describe 'shopping_cart' do
  before do
    visit '/products/ruby-on-rails-bag'
    click_button 'Add To Cart'
    visit '/products/ruby-on-rails-tote'
    click_button 'Add To Cart'
    click_button 'Checkout'
  end

  context 'New Account' do
    before do
      fill_in 'spree_user_email', with: Faker::Internet.unique.email
      fill_in 'spree_user_password', with: ENV['PASSWORD_SPREE']
      fill_in 'spree_user_password_confirmation', with: ENV['PASSWORD_SPREE']

      find_button('Create').click
    end

    xit 'has all blocks'
    xit 'can save billing address'
    xit 'can save shipping different from billing'

    xit 'can see all line-items'
    xit 'can choose Shipping method'
    xit 'taxes are displayed'

    xit 'can save cc'
    xit 'cant use cc with wrong info'
    xit 'whats this info'
    xit 'can choose check'
    xit 'can add the promo'

    xit 'can edit billing'
    xit 'can edit shipping'
    xit 'can edit shipping method'
    xit 'can edit payment'

    xit 'can place the order'
    xit 'can see all info'
  end

  context 'Existing Account' do
    before do
      find('a', text: 'Login as Existing Customer').click

      fill_in 'spree_user_email', with: ENV['USERNAME_SPREE']
      fill_in 'spree_user_password', with: ENV['PASSWORD_SPREE']

      find_button('Login').click
    end

    xit 'has all blocks'
    xit 'can change and save billing address'
    xit 'can change and save shipping different from billing'
    xit 'stores address to my_account'
    xit 'doesnt store my address to my_account'

    xit 'can see all line-items'
    xit 'can choose Shipping method'
    xit 'taxes are displayed'

    xit 'can use stored cc'
    xit 'can save new cc'
    xit 'cant use cc with wrong info'
    xit 'whats this info'
    xit 'can choose check'
    xit 'can add the promo'

    xit 'can edit billing'
    xit 'can edit shipping'
    xit 'can edit shipping method'
    xit 'can edit payment'

    xit 'can place the order'
    xit 'can see all info'
  end

  context 'Guest' do
    before do
      fill_in 'order_email', with: ENV['USERNAME_SPREE']
      find_button('Continue').click
    end

    it 'has all blocks' do # e-mail, billing/shipping, order summary, save/continue
      byebug
    end

    xit 'can save billing address'
    xit 'can save shipping different from billing'

    xit 'can see all line-items'
    xit 'can choose Shipping method'
    xit 'taxes are displayed'

    xit 'can save cc'
    xit 'cant use cc with wrong info'
    xit 'whats this info'
    xit 'can choose check'
    xit 'can add the promo'

    xit 'can edit billing'
    xit 'can edit shipping'
    xit 'can edit shipping method'
    xit 'can edit payment'

    xit 'can place the order'
    xit 'can see all info'
  end
end