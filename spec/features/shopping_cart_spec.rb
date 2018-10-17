describe 'shopping_cart' do
  after { logout }

  context 'empty cart' do
    before { visit '/cart' }

    xit 'header displays Empty'
    xit 'displays the title of the page'
    xit 'your cart is empty'
    xit 'has Continue Shopping button'
  end

  context 'displaying info when there are products in the cart' do
    before do
      visit '/ruby-on-rails-bag'
      click_button 'Add To Cart'
    end

    xit 'header displays number of items in the cart'
    xit 'header displays the total sum'
    xit 'displays titles of the table'
    xit 'the link with product name'
    xit 'has product description'
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

