# frozen_string_literal: true

shared_examples 'Address step' do
  scenario 'has all blocks' do
    aggregate_failures do
      expect(page).to have_css('div[data-hook="checkout_header"]')
      expect(page).to have_css('.first', text: 'Address')
      expect(page).to have_css('.next', text: 'Delivery')
      expect(page).to have_css('li', text: 'Payment')
      expect(page).to have_css('.last', text: 'Complete')
      expect(page).to have_css('.form-group', text: 'Customer E-Mail')
      expect(page).to have_css('.panel-heading', text: 'Billing Address')
      expect(page).to have_css('.panel-heading', text: 'Shipping Address')
      expect(page).to have_css('#checkout-summary', text: 'Order Summary')

      expect(page).to have_button 'Save and Continue'
    end
  end

  scenario 'can save Billing' do
    fill_in_billing(user)
    click_on 'Save and Continue'

    expect(page).to have_css('.active', text: 'Delivery')
  end

  scenario 'can save Shipping different from Billing' do
    fill_in_billing(user)
    uncheck 'Use Billing Address'

    fill_in_shipping(user2)
    click_on 'Save and Continue'

    expect(page).to have_css('.active', text: 'Delivery')
  end
end

shared_examples 'Delivery step' do
  before { save_address(billing: user) }

  scenario 'has all blocks' do
    aggregate_failures do
      expect(page).to have_css('.panel-heading', text: 'Delivery')
      expect(page).to have_css('#methods')
      expect(page).to have_css('th', text: 'Item')
      expect(page).to have_css('th', text: 'Qty')
      expect(page).to have_css('th', text: 'Price')
      expect(page).to have_css('.stock-contents')
      expect(page).to have_css('.stock-shipping-method-title', text: 'Shipping Method')

      shipping_method = all('.shipping-method').map(&:text)
      expect(shipping_method).to include 'UPS Ground (USD) $5.00'
      expect(shipping_method).to include 'UPS Two Day (USD) $10.00'
      expect(shipping_method).to include 'UPS One Day (USD) $15.00'

      expect(page).to have_css('#checkout-summary')
      expect(page).to have_content 'Order Summary'
      expect(page).to have_css('tr[data-hook="item_total"]')
      expect(page).to have_css('tbody[data-hook="order_details_tax_adjustments"]')
      expect(page).to have_css('tr[data-hook="shipping_total"]')
      expect(page).to have_css('tr[data-hook="order_total"]')

      expect(page).to have_button 'Save and Continue'
    end
  end

  scenario 'shipping methods can be changed' do
    aggregate_failures do
      choose 'UPS One Day (USD)'
      expect(page).to have_css('tr[data-hook="shipping_total"]', text: '$15.00')

      choose 'UPS Ground (USD)'
      expect(page).to have_css('tr[data-hook="shipping_total"]', text: '$5.00')

      choose 'UPS Two Day (USD)'
      expect(page).to have_css('tr[data-hook="shipping_total"]', text: '$10.00')
    end
  end

  scenario 'taxes are calculated correctly' do
    item_total = find('tr[data-hook="item_total"]').text.split.last.delete('$').to_f
    taxes_percent = find('.total').text.split[-2].chop.to_f
    taxes = find('.total').text.split.last.delete('$').to_f
    calculation = (item_total * taxes_percent / 100).round(2)

    expect(taxes).to eq calculation
  end

  scenario 'shipping methods can be saved' do
    delivery_costs = all('.rate-cost').map(&:text)
    delivery_costs.each do |delivery_cost|
      within('.shipping-methods') { choose delivery_cost }

      click_on 'Save and Continue'

      shipping_total = find('td[data-hook="shipping-total"]').text

      aggregate_failures do
        expect(page).to have_css('.active', text: 'Payment')
        expect(shipping_total).to eq delivery_cost
      end

      click_on 'Delivery'
    end
  end
end

shared_examples 'Payment step' do
  before do
    save_address(billing: user)
    save_delivery
  end

  scenario 'has all blocks' do
    aggregate_failures do
      expect(page).to have_css('.panel-title', text: 'Payment Information')
      expect(page).to have_css('#order_payments_attributes__payment_method_id_1')
      expect(page).to have_css('#order_payments_attributes__payment_method_id_2')

      expect(page).to have_css('#credit-card-image')
      expect(page).to have_css('#name_on_card_1')
      expect(page).to have_css('#card_number')
      expect(page).to have_css('#card_expiry')
      expect(page).to have_css('#card_code')
      expect(page).to have_css('#cvv_link', text: "What's This?")
      expect(page).to have_css('#order_coupon_code')

      expect(page).to have_css('#checkout-summary')
      expect(page).to have_content 'Order Summary'
      expect(page).to have_css('tr[data-hook="item_total"]')
      expect(page).to have_css('tbody[data-hook="order_details_tax_adjustments"]')
      expect(page).to have_css('tr[data-hook="shipping_total"]')
      expect(page).to have_css('tr[data-hook="order_total"]')

      expect(page).to have_button 'Save and Continue'
    end
  end

  scenario 'has correct info on Payment page' do
    full_name = "#{user.first_name} #{user.last_name}"
    name_on_card = find('#name_on_card_1').value

    expect(name_on_card).to eq full_name
  end

  # skipped since it's bug: for now it's possible to save invalid card
  xscenario "can't save CC with invalid info" do
    fill_in 'card_number', with: '0000000000000000'
    fill_in 'card_expiry', with: '00/00'
    fill_in 'card_code', with: '000'

    click_on 'Save and Continue'
    expect(page).to have_css('.alert-danger')
  end

  scenario 'can save credit card' do
    fill_in_cc(credit_card)
    click_on 'Save and Continue'

    expect(page).to have_css('.active', text: 'Confirm')
  end

  scenario 'can pay via check' do
    choose 'Check'

    click_on 'Save and Continue'

    expect(page).to have_css('.alert-notice', text: 'Your order has been processed successfully')
  end

  scenario 'can add promocode' do
    fill_in_cc(credit_card)
    fill_in 'order_coupon_code', with: 'segment'

    click_on 'Save and Continue'

    expect(page).to have_css('.total', text: 'Promotion')
  end
end

shared_examples 'Confirmation step' do
  before do
    save_address(billing: user)
    save_delivery
    save_payment(credit_card)
  end

  scenario 'has all blocks' do
    aggregate_failures do
      expect(page).to have_css('div[data-hook="checkout_header"]')
      expect(page).to have_css('.col-sm-3', text: 'Checkout')
      expect(page).to have_css('.completed', text: 'Address')
      expect(page).to have_css('.completed', text: 'Delivery')
      expect(page).to have_css('.completed', text: 'Payment')
      expect(page).to have_css('.completed', text: 'Address')
      expect(page).to have_css('.active', text: 'Confirm')
      expect(page).to have_css('.last', text: 'Complete')

      expect(page).to have_css('.panel-heading', text: 'Confirm')
      expect(page).to have_css('.col-xs-6', text: 'Billing Address')
      expect(page).to have_css('.col-xs-6', text: 'Shipping Address')
      expect(page).to have_css('.col-xs-6', text: 'Shipments')
      expect(page).to have_css('.col-xs-6', text: 'Payment Information')

      expect(page).to have_css('.active', text: 'Item')
      expect(page).to have_css('.active', text: 'Price')
      expect(page).to have_css('.active', text: 'Qty')
      expect(page).to have_css('.active', text: 'Total')
      expect(page).to have_css('#line-items')

      expect(page).to have_css('.total', text: 'Subtotal')
      expect(page).to have_css('.total', text: 'Shipping')
      expect(page).to have_css('.total', text: 'Tax')
      expect(page).to have_css('.total', text: 'Order Total')

      expect(page).to have_button 'Place Order'
    end
  end

  scenario 'can place the order' do
    click_on 'Place Order'

    aggregate_failures do
      expect(page).to have_css('.alert-notice', text: 'Your order has been processed successfully')
      expect(page).to have_link 'Back to Store'
    end
  end

  describe 'Editing info using Navigation' do
    scenario 'Billing Address' do
      find('.completed', text: 'Address').click
      expect(page).to have_css('.active', text: 'Address')

      save_address(billing: user2)
      save_delivery
      save_payment(credit_card)

      order_bill_address = find('div[data-hook="order-bill-address"]')

      within(order_bill_address) do
        user2.to_hash.each do |key, value|
          value = Madison.get_abbrev(value) if key == :state

          expect(order_bill_address).to have_content value
        end
      end
    end

    scenario 'Shipping method' do
      find('.completed', text: 'Delivery').click
      expect(page).to have_css('.active', text: 'Delivery')

      save_delivery('UPS One Day (USD)')
      save_payment(credit_card)

      expect(page).to have_css('.delivery', text: 'From default via UPS One Day (USD)')
    end

    scenario 'Payment' do
      find('.completed', text: 'Payment').click
      expect(page).to have_css('.active', text: 'Payment')

      save_payment(credit_card2)

      expect(page).to have_css('.payment-info', text: 'Ending in 2222')
    end
  end

  describe 'Editing info using button' do
    scenario 'Billing Address' do
      find('h4', text: 'Billing Address').click_on 'Edit'
      expect(page).to have_css('.active', text: 'Address')

      save_address(billing: user2)
      save_delivery
      save_payment(credit_card)

      order_bill_address = find('div[data-hook="order-bill-address"]')
      within(order_bill_address) do
        user2.to_hash.each do |key, value|
          value = Madison.get_abbrev(value) if key == :state

          expect(order_bill_address).to have_content value
        end
      end
    end

    scenario 'Shipping Address' do
      find('h4', text: 'Shipping Address').click_on 'Edit'
      expect(page).to have_css('.active', text: 'Address')

      save_address(billing: user, shipping: user2)
      save_delivery
      save_payment(credit_card)

      order_bill_address = find('div[data-hook="order-bill-address"]')
      order_ship_address = find('div[data-hook="order-ship-address"]')

      within(order_bill_address) do
        user.to_hash.each do |key, value|
          value = Madison.get_abbrev(value) if key == :state

          expect(order_bill_address).to have_content value
        end
      end

      within(order_ship_address) do
        user2.to_hash.each do |key, value|
          value = Madison.get_abbrev(value) if key == :state

          expect(order_ship_address).to have_content value
        end
      end
    end

    scenario 'Shipping method' do
      find('h4', text: 'Shipments').click_on 'Edit'
      expect(page).to have_css('.active', text: 'Delivery')

      save_delivery('UPS One Day (USD)')
      save_payment(credit_card)

      expect(page).to have_css('.delivery', text: 'From default via UPS One Day (USD)')
    end

    scenario 'Payment' do
      find('h4', text: 'Payment Information').click_on 'Edit'
      expect(page).to have_css('.active', text: 'Payment')

      save_payment(credit_card2)

      expect(page).to have_css('.payment-info', text: 'Ending in 2222')
    end
  end
end
