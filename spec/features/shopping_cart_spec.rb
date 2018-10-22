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

    it 'header displays number of items in the cart' do
      fill_in 'order_line_items_attributes_0_quantity', with: rand(2...10)
      click_button 'update-button'

      quantity = find('#order_line_items_attributes_0_quantity').value.to_i
      header_items = find('.full').text.split('$')[0][/\d/].to_i

      expect(quantity).to eql header_items
    end

    it 'header displays the total sum' do
      fill_in 'order_line_items_attributes_0_quantity', with: rand(2...10)
      click_button 'update-button'

      total = find('.cart-total').text.split('$')[1].to_f
      header_total = find('.amount').text.split('$')[1].to_f

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

    it 'can change the quantity' do
      fill_in 'order_line_items_attributes_0_quantity', with: rand(2...10)
      click_button 'update-button'

      fill_in 'order_coupon_code', with: 'segment'
      click_button 'Apply'

      quantity = find('#order_line_items_attributes_0_quantity').value.to_i
      number_of_items = find('.cart-subtotal').text.split('$')[0][/\d/].to_i

      expect(quantity).to eql number_of_items
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

      one_item_price = find('.cart-item-price').text.split('$')[1].to_f
      quantity = find('#order_line_items_attributes_0_quantity').value.to_i
      total_calculation = one_item_price * quantity
      total_cart = find('.cart-item-total').text.split('$')[1].to_f

      expect(total_cart).to eq total_calculation.round(2)
    end

    it 'Total for the whole order' do
      visit '/products/ruby-on-rails-tote'
      click_button 'Add To Cart'

      total_for_item = all('.cart-item-total').to_a
      total1 = total_for_item[0].text.split('$')[1].to_f
      total2 = total_for_item[1].text.split('$')[1].to_f
      total_for_order = find('.cart-total').text.split('$')[1].to_f

      expect(total_for_order).to eql(total1 + total2)
    end

    it 'add discount code and see calculations' do
      fill_in 'order_coupon_code', with: 'segment'
      click_button 'Apply'

      subtotal = find('.cart-subtotal').text.split('$')[1].to_f
      promotion = (subtotal / 2).round(2)
      to_pay = (subtotal - promotion).round(2)
      total = find('.cart-total').text.split('$')[1].to_f

      expect(total).to eql to_pay

      quantity = find('#order_line_items_attributes_0_quantity').value.to_i
      number_of_items = find('.cart-subtotal').text.split('$')[0][/\d/].to_i

      expect(quantity).to eql number_of_items
    end
  end
end