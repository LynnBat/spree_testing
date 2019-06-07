# frozen_string_literal: true

RSpec.feature 'Shopping Cart' do
  let(:number) { rand(2...10) }
  let(:router) { Router.new }

  scenario 'empty cart has all blocks' do
    visit router.cart_path

    aggregate_failures do
      expect(page).to have_css('.empty', text: 'Empty')
      expect(page).to have_css('.col-sm-12', text: 'Shopping Cart')
      expect(page).to have_css('.alert-info', text: 'Your cart is empty')
      expect(page).to have_css('.btn-default', text: 'Continue shopping')
    end
  end

  describe 'Cart with products' do
    before { add_to_cart(router.pdp_path) }

    scenario 'has all blocks' do
      aggregate_failures do
        expect(page).to have_css('.cart-item-description-header', text: 'Item')
        expect(page).to have_css('.cart-item-price-header', text: 'Price')
        expect(page).to have_css('.cart-item-quantity-header', text: 'Qty')
        expect(page).to have_css('.cart-item-total-header', text: 'Total')

        expect(page).to have_css('.line-item')
        expect(page).to have_css('.line_item_quantity')
        expect(page).to have_css('.delete')
        expect(page).to have_css('.cart-total')

        expect(page).to have_css('#clear_cart_link')
        expect(page).to have_css('.continue', text: 'Continue shopping')
        expect(page).to have_css('#order_coupon_code')
        expect(page).to have_css('.btn-default', text: 'Apply')
        expect(page).to have_css('.btn-primary', text: 'Update')
        expect(page).to have_css('.btn-success', text: 'Checkout')
      end
    end

    scenario 'can delete the item by setting the quantity to 0' do
      fill_in 'order_line_items_attributes_0_quantity', with: 0
      click_on 'update-button'

      expect(page).to have_css('.alert-info', text: 'Your cart is empty')
    end

    scenario 'can delete the item by clicking delete button' do
      find('.delete').click

      expect(page).to have_css('.alert-info', text: 'Your cart is empty')
    end

    context 'Calculations' do
      before do
        fill_in 'order_line_items_attributes_0_quantity', with: number
        click_on 'update-button'
      end

      scenario 'header displays number of items in the cart' do
        header_items = find('.full').text.split('$')[0][/\d/].to_i

        expect(number).to eq header_items
      end

      scenario 'header displays the total sum' do
        header_total = find('.amount').text.delete('$')
        total = find('.cart-total').text.split('$')[1]

        expect(total).to eq header_total
      end

      scenario 'total per item' do
        one_item_price = find('.cart-item-price').text.delete('$').to_f
        total_calculation = one_item_price * number
        total_cart = find('.cart-item-total').text.delete('$').to_f

        expect(total_cart).to eq total_calculation.round(2)
      end

      scenario 'total for the whole order' do
        add_to_cart(router.pdp2_path)

        first_total  = first('.cart-item-total').text.delete('$').to_f
        second_total = all('.cart-item-total').last.text.delete('$').to_f
        total_for_order = find('.cart-total').text.split('$')[1].to_f

        expect(total_for_order).to eq(first_total + second_total)
      end

      scenario '50% off promocode' do
        fill_in 'order_coupon_code', with: 'segment'
        click_on 'Apply'

        subtotal = find('.cart-subtotal').text.split('$')[1].to_f
        promotion = (subtotal / 2).round(2)
        to_pay = (subtotal - promotion).round(2)
        total = find('.cart-total').text.split('$')[1].to_f

        expect(total).to eq to_pay
      end
    end
  end
end
