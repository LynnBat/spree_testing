describe 'shopping_cart' do
  after { logout }

  context 'empty cart' do
    before { visit '/cart' }

    it 'header displays Empty' do
      expect(page).to have_css('a', text: 'Empty')
    end

    it 'displays the title of the page' do
      expect(page).to have_css('.col-sm-12', text: 'Shopping Cart')
    end

    it 'your cart is empty' do
      expect(page).to have_css('.alert-info', text: 'Your cart is empty')
    end

    it 'has Continue Shopping button' do
      expect(page).to have_css('.btn-default')
    end
  end

  context 'displaying info when there are products in the cart' do
    before do
      visit '/products/ruby-on-rails-bag'
      click_button 'Add To Cart'
    end

    xit 'header displays number of items in the cart'
    xit 'header displays the total sum'

    it 'displays titles of the table' do
      expect(page).to have_css('.cart-item-description-header', text: 'Item')
      expect(page).to have_css('.cart-item-price-header', text: 'Price')
      expect(page).to have_css('.cart-item-quantity-header', text: 'Qty')
      expect(page).to have_css('.cart-item-total-header', text: 'Total')
    end

    it 'the link with product name' do
      expect(page).to have_css('a', text: 'Ruby on Rails Bag')
    end

    it 'has product description' do
      byebug
    end
    xit 'has Checkout button'
    xit 'has Continue Shopping button'
  end

  context 'changes in the cart' do
    before do
      visit '/ruby-on-rails-bag'
      click_button 'Add To Cart'
    end

    xit 'can change the quantity'
    xit 'can delete the item'
    xit 'can add more items'
    xit 'can Empty the cart'
    xit 'can add/remove the GWP Code'
  end

  context 'calculations' do
    before do
      visit '/ruby-on-rails-bag'
      click_button 'Add To Cart'
    end

    xit 'header changes number of products'
    xit 'header changes the price'
    xit 'Total for each Item Calculations'
    xit 'Total for the whole order'
    xit 'add/remove discount code and see calculations'
  end
end

