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

    xit 'header displays number of items in the cart' do
      fill_in 'order_line_items_attributes_0_quantity', with: rand(2...10)

      click_button 'update-button'

      quantity = find('#order_line_items_attributes_0_quantity').value.to_i
      # have to find the number, same gsub as below
      header_items = 

      expect(quantity).to eql header_items
    end

    it 'header displays the total sum' do
      fill_in 'order_line_items_attributes_0_quantity', with: rand(2...10)
      click_button 'update-button'

      quantity = find('#order_line_items_attributes_0_quantity').value.to_i
      total = find('.cart-total').text.gsub(/[^\d\.]/, '').to_f
      header_total = find('.amount').text.gsub(/[^\d\.]/, '').to_f

      expect(total).to eql header_total
    end

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
      expect(page).to have_css('span.line-item-description', text: 'Odit vel esse voluptatibus est vero repellat')
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
      fill_in 'order_line_items_attributes_0_quantity', with: rand(2...10)
      click_button 'update-button'

      quantity = find('#order_line_items_attributes_0_quantity').value.to_i
      # I need to fix gsub here
      number_of_items = find('.cart-subtotal').text.gsub(/[^\d{2}\.\d{2}]/, '')

      expect(quantity).to egl number_of_items
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

    it 'Total for each Item Calculations' do
      fill_in 'order_line_items_attributes_0_quantity', with: rand(2...10)
      click_button 'update-button'

      one_item_price = find('.cart-item-price').text.gsub(/[^\d\.]/, '').to_f
      quantity = find('#order_line_items_attributes_0_quantity').value.to_i
      total_calculation = one_item_price * quantity
      total_cart = find('.cart-item-total').text.gsub(/[^\d\.]/, '').to_f

      expect(total_cart).to eq total_calculation.round(2)
    end

    xit 'Total for the whole order' do
      visit '/products/ruby-on-rails-tote'
      click_button 'Add To Cart'

      # find all and add all of them
      find_all('.cart-item-total')[taxonomy_number]
    end

    xit 'add discount code and see calculations' do
      fill_in 'order_coupon_code', with: 'segment'
      click_button 'Apply'

      # I need to fix gsub here
      subtotal = find('.cart-subtotal').text.gsub(/[^\d{2}\.\d{2}]/, '')
      promotion = subtotal / 2
      to_pay = subtotal - promotion.round(2)
      total = find('.cart-total').text.gsub(/[^\d\.]/, '').to_f

      expect(total).to eql to_pay
    end
  end
end