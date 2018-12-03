shared_examples 'Address step' do
  it 'displays info on Address step' do
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

      expect(page).to have_button('Save and Continue')
    end
  end

  it 'default country is USA' do
    uncheck 'order_use_billing'

    aggregate_failures do
      expect(page).to have_css('#order_bill_address_attributes_country_id', text: 'United States of America')
      expect(page).to have_css('#order_ship_address_attributes_country_id', text: 'United States of America')
    end
  end

  it 'can save Billing' do
    fill_in_billing(address)
    click_button 'Save and Continue'

    expect(page).to have_css('.active', text: 'Delivery')
  end

  it 'can save Shipping different from Billing' do
    fill_in_billing(address)
    uncheck 'order_use_billing'

    fill_in_shipping(address2)
    click_button 'Save and Continue'

    expect(page).to have_css('.active', text: 'Delivery')
  end
end

shared_examples 'Delivery step' do
  before { save_address(address) }

  it 'has shipping methods, line-items' do
    shipping_method = all('.rate-cost')
    ups_ground = shipping_method[0].text
    ups_two_day = shipping_method[1].text
    ups_one_day = shipping_method[2].text

    aggregate_failures do
      expect(page).to have_css('.rate-name', text: 'UPS Ground (USD)')
      expect(ups_ground).to eq '$5.00'
      expect(page).to have_css('.rate-name', text: 'UPS Two Day (USD)')
      expect(ups_two_day).to eq '$10.00'
      expect(page).to have_css('.rate-name', text: 'UPS One Day (USD)')
      expect(ups_one_day).to eq '$15.00'
      expect(page).to have_css('.item-name', text: 'Ruby on Rails Bag')
      expect(page).to have_css('.item-name', text: 'Ruby on Rails Tote')
    end
  end

  it 'shipping methods can be changed' do
    choose('UPS One Day (USD)')
    expect(page).to have_css('tr[data-hook="shipping_total"]', text: '$15.00')

    choose('UPS Ground (USD)')
    expect(page).to have_css('tr[data-hook="shipping_total"]', text: '$5.00')

    choose('UPS Two Day (USD)')
    expect(page).to have_css('tr[data-hook="shipping_total"]', text: '$10.00')
  end

  it 'taxes are displayed' do
    taxes = find('.total').text

    expect(taxes).to eq('North America 5.0% $1.95')
  end

  it 'shipping methods can be saved' do
    click_button 'Save and Continue'

    expect(page).to have_css('.active', text: 'Payment')
  end
end

shared_examples 'Payment step' do
  before { save_delivery('UPS Two Day (USD)', address) }

  xit 'cant save credit card with invalid info' # bug

  it 'has correct info on Payment page' do
    full_name = "#{address[:first_name]} #{address[:last_name]}"
    name_on_card = find('#name_on_card_1').value

    aggregate_failures do
      expect(page).to have_css('.panel-heading', text: 'Payment Information')
      expect(name_on_card).to eq full_name
      expect(page).to have_css('#cvv_link', text: "What's This?")
    end
  end

  it 'can save credit card' do
    fill_in_cc(credit_card)
    click_button 'Save and Continue'

    expect(page).to have_css('.active', text: 'Confirm')
  end

  it 'can pay via check' do
    choose('order_payments_attributes__payment_method_id_2')

    click_button 'Save and Continue'

    expect(page).to have_css('.alert-notice', text: 'Your order has been processed successfully')
  end

  it 'can add promocode' do
    fill_in_cc(credit_card)
    fill_in 'order_coupon_code', with: 'segment'

    click_button 'Save and Continue'

    expect(page).to have_css('.total', text: 'Promotion (Segment)')
  end
end

shared_examples 'Confirmation step' do
  before { save_payment(credit_card, 'UPS Two Day (USD)', address) }

  it 'info is visable' do
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
      expect(page).to have_css('#line-items', text: 'Ruby on Rails Bag')
      expect(page).to have_css('#line-items', text: 'Ruby on Rails Tote')

      expect(page).to have_css('.total', text: 'Subtotal')
      expect(page).to have_css('.total', text: 'Shipping')
      expect(page).to have_css('.total', text: 'Tax')
      expect(page).to have_css('.total', text: 'Order Total')

      expect(page).to have_button('Place Order')
    end
  end

  it 'can place the order' do
    click_button 'Place Order'

    aggregate_failures do
      expect(page).to have_css('.alert-notice', text: 'Your order has been processed successfully')
      expect(page).to have_css('.button', text: 'Back to Store')
    end
  end
end

shared_examples 'can edit on Confirmation step' do |name, title, order_number = nil|
  before { save_payment(credit_card, 'UPS Two Day (USD)', address) }

  it name do
    find('.completed', text: title).click if name.include?('navigation')
    find('.steps-data').all('h4 a')[order_number].click if name.include?('button')

    expect(page).to have_css('.active', text: title)

    if name.include?('Billing')
      save_payment(credit_card, 'UPS Two Day (USD)', address2)
      order_bill_address = find('div[data-hook="order-bill-address"]')

      within(order_bill_address) do
        address2.each do |key, value|
          # the application changes states to their short titles
          value = 'IL' if key == :state
          expect(page).to have_content(value)
        end
      end
    end

    if name.include?('Shipping Address')
      save_payment(credit_card, 'UPS Two Day (USD)', address, address2)
      order_bill_address = find('div[data-hook="order-bill-address"]')
      order_ship_address = find('div[data-hook="order-ship-address"]')

      within(order_bill_address) do
        address.each do |key, value|
          value = 'CA' if key == :state
          expect(page).to have_content(value)
        end
      end

      within(order_ship_address) do
        address2.each do |key, value|
          value = 'IL' if key == :state
          expect(page).to have_content(value)
        end
      end
    end

    if name.include?('Shipping method')
      save_delivery('UPS One Day (USD)')
      save_payment(credit_card, 'UPS One Day (USD)')

      expect(page).to have_css('.delivery', text: 'From default via UPS One Day (USD)')
    end

    if name.include?('Payment')
      save_payment(credit_card2)

      expect(page).to have_css('.payment-info', text: 'Ending in 2222')
    end
  end
end