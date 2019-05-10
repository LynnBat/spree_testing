# frozen_string_literal: true

RSpec.feature 'shopping_cart' do
  let(:number) { rand(2...10) }
  after { logout }

  scenario 'empty cart checks' do
    visit '/cart'
    aggregate_failures do
      expect(page).to have_css('.empty', text: 'Empty')
      expect(page).to have_css('.col-sm-12', text: 'Shopping Cart')
      expect(page).to have_css('.alert-info', text: 'Your cart is empty')
      expect(page).to have_css('.btn-default', text: 'Continue shopping')
    end
  end

  describe '1 line item 1 quantity' do
    before do
      visit '/products/ruby-on-rails-bag'
      click_button 'Add To Cart'
    end

    scenario 'displays titles of the table' do
      aggregate_failures do
        expect(page).to have_css('.cart-item-description-header', text: 'Item')
        expect(page).to have_css('.cart-item-price-header', text: 'Price')
        expect(page).to have_css('.cart-item-quantity-header', text: 'Qty')
        expect(page).to have_css('.cart-item-total-header', text: 'Total')
      end
    end

    scenario 'has item info and checkout/continue shopping buttons' do
      aggregate_failures do
        expect(page).to have_css('a', text: 'Ruby on Rails Bag')
        expect(page).to have_css('span.line-item-description', text: 'Qui veritatis qui impedit et quia officiis rem eligendi')
        expect(page).to have_css('#checkout-link')
        expect(page).to have_css('a', text: 'Continue shopping')
      end
    end

    scenario 'can delete the item' do
      find('.delete').click

      expect(page).to have_css('.alert-info', text: 'Your cart is empty')
    end

    scenario 'item deletes automatically after setting the quantity to 0' do
      fill_in 'order_line_items_attributes_0_quantity', with: 0
      click_button 'update-button'

      expect(page).to have_css('.alert-info', text: 'Your cart is empty')
    end
  end

  describe '1 line item, quantity > 1' do
    before do
      visit '/products/ruby-on-rails-bag'
      click_button 'Add To Cart'
      fill_in 'order_line_items_attributes_0_quantity', with: number
      click_button 'update-button'
    end

    scenario 'header displays number of items in the cart' do
      header_items = find('.full').text.split('$')[0][/\d/].to_i

      expect(number).to eq header_items
    end

    scenario 'header displays the total sum' do
      total = find('.cart-total').text.split('$')[1]
      header_total = find('.amount').text.split('$')[1]

      expect(total).to eq header_total
    end

    scenario 'total for each item calculations' do
      one_item_price = find('.cart-item-price').text.split('$')[1].to_f
      total_calculation = one_item_price * number
      total_cart = find('.cart-item-total').text.split('$')[1].to_f

      expect(total_cart).to eq total_calculation.round(2)
    end
  end

  describe 'more than 1 line item' do
    before do
      visit '/products/ruby-on-rails-bag'
      click_button 'Add To Cart'
      visit '/products/ruby-on-rails-tote'
      click_button 'Add To Cart'
    end

    scenario 'can Empty the cart' do
      click_button 'Empty Cart'

      expect(page).to have_css('.alert-info', text: 'Your cart is empty')
    end

    scenario 'Total for the whole order' do
      total_for_item = all('.cart-item-total')
      total1 = total_for_item[0].text.split('$')[1].to_f
      total2 = total_for_item[1].text.split('$')[1].to_f
      total_for_order = find('.cart-total').text.split('$')[1].to_f

      expect(total_for_order).to eq(total1 + total2)
    end
  end

  describe 'promotion' do
    before do
      visit '/products/ruby-on-rails-bag'
      click_button 'Add To Cart'
    end

    scenario 'can add the GWP Code' do
      fill_in 'order_coupon_code', with: 'gwp'
      click_button 'Apply'

      expect(page).to have_css('a', text: 'Spree Mug')
    end

    scenario 'add discount code and see calculations' do
      fill_in 'order_coupon_code', with: 'segment'
      click_button 'Apply'

      subtotal = find('.cart-subtotal').text.split('$')[1].to_f
      promotion = (subtotal / 2).round(2)
      to_pay = (subtotal - promotion).round(2)
      total = find('.cart-total').text.split('$')[1].to_f

      expect(total).to eq to_pay

      quantity = find('#order_line_items_attributes_0_quantity').value
      number_of_items = find('.cart-subtotal').text.split('$')[0][/\d/]

      expect(quantity).to eq number_of_items
    end
  end
end
