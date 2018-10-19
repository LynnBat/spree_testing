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

    it 'has the link with product name' do
      expect(page).to have_css('a', text: 'Ruby on Rails Bag')
    end

    it 'has product description' do
      byebug
      #expect('.line-item-description').to match "Odit vel esse voluptatibus est vero repellat"
    end
    it 'has Checkout button' do
      expect(page).to have_css('#checkout-link')
    end

    it 'has Continue Shopping button' do
      expect(page).to have_css('a', text: 'Continue shopping')
    end
  end

  context 'changes in the cart' do
    before do
      visit '/products/ruby-on-rails-bag'
      click_button 'Add To Cart'
    end

    xit 'can change the quantity' do
      fill_in 'order_line_items_attributes_0_quantity', with: rand(1...10)
      click_button 'update-button'
      #total = cart_item_price.to_i * .line_item_quantity.to_i
      #expect(cart_item_total).to eq total
    end

    it 'can add more items' do
      visit '/products/ruby-on-rails-tote'
      click_button 'Add To Cart'
      expect(page).to have_css('a', text: 'Ruby on Rails Bag')
      expect(page).to have_css('a', text: 'Ruby on Rails Tote')
    end

    it 'can delete the item' do
      find('.delete').click
      expect(page).to have_css('.alert-info', text: 'Your cart is empty')
    end

    it 'item deletes automatically after setting the quantity to 0' do
      fill_in 'order_line_items_attributes_0_quantity', with: 0
      click_button 'update-button'
      expect(page).to have_css('.alert-info', text: 'Your cart is empty')
    end

    it 'can Empty the cart' do
      click_button 'Empty Cart'
      expect(page).to have_css('.alert-info', text: 'Your cart is empty')
    end

    it 'can add the GWP Code' do
      fill_in 'order_coupon_code', with: 'gwp'
      click_button 'Apply'
      expect(page).to have_css('a', text: 'Spree Mug')
    end
  end

  context 'calculations' do
    before do
      visit '/products/ruby-on-rails-bag'
      click_button 'Add To Cart'
    end

    xit 'header changes number of products'
    xit 'header changes the price'
    xit 'Total for each Item Calculations'
    xit 'Total for the whole order'

    xit 'add discount code and see calculations' do
      fill_in 'order_coupon_code', with: 'segment'
      click_button 'Apply'
      expect(page).to have_css('.adjustment', text: "Adjustment: Promotion (Discount)")
    end
  end
end