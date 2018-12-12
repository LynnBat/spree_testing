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
    uncheck 'Use Billing Address'

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
    uncheck 'Use Billing Address'

    fill_in_shipping(address2)
    click_button 'Save and Continue'

    expect(page).to have_css('.active', text: 'Delivery')
  end
end

shared_examples 'Delivery step' do
  before { save_address(address) }
=begin
  it 'has shipping methods, line-items' do
    shipping_method_cost = all('.rate-cost')
    ups_ground = shipping_method_cost[0].text
    ups_two_day = shipping_method_cost[1].text
    ups_one_day = shipping_method_cost[2].text

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
=end
  it 'taxes are calculated correctly' do
    item_total = find('tr[data-hook="item_total"]').text.split[-1]
    taxes_percent = find('.total').text.split[-2]
    taxes = find('.total').text.split[-1]
    byebug

    # need to change that for a Faker
    expect(taxes).to eq #calculation total * taxes_percent / 100%
  end

  it 'shipping methods can be saved' do
    click_button 'Save and Continue'

    expect(page).to have_css('.active', text: 'Payment')
  end

  it 'shipping methods can be saved' do
    delivery_method_costs = all('.rate-cost').collect(&:text)
    delivery_method_costs.each do |delivery_method_cost|
      within('.shipping-methods') { choose delivery_method_cost }

      click_button 'Save and Continue'

      shipping_total = find('td[data-hook="shipping-total"]').text

      aggregate_failures do
        expect(page).to have_css('.active', text: 'Payment')
        expect(shipping_total).to eq delivery_method_cost
      end

      click_link 'Delivery'
    end
  end
end

shared_examples 'Payment step' do
  before do
    save_address(address)
    save_delivery('UPS Two Day (USD)')
  end

  it 'cant save credit card with invalid Month' do
    credit_card[:expiry_date] = '00/00'

    fill_in_cc(credit_card)
    click_button 'Save and Continue'

    expect(page).to have_css('.alert-danger')
  end

  it 'cant save credit card with invalid CC number' do
    credit_card[:number] = '0000000000000000'

    fill_in_cc(credit_card)
    click_button 'Save and Continue'

    expect(page).to have_css('.alert-danger')
  end

  it 'cant save credit card with invalid verification number' do
    credit_card[:cvv] = '0'

    fill_in_cc(credit_card)
    click_button 'Save and Continue'

    expect(page).to have_css('.alert-danger')
  end

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
    choose 'Check'

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
  before do
    save_address(address)
    save_delivery('UPS Two Day (USD)')
    save_payment(credit_card)
  end

  it 'info is visible' do
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

shared_examples 'can edit on Confirmation step' do
  before do
    save_address(address)
    save_delivery('UPS Two Day (USD)')
    save_payment(credit_card)
  end

  context 'using Navigation' do
    it 'Billing Address' do
      find('.completed', text: 'Address').click
      expect(page).to have_css('.active', text: 'Address')

      save_address(address2)
      save_delivery('UPS Two Day (USD)')
      save_payment(credit_card)

      order_bill_address = find('div[data-hook="order-bill-address"]')

      within(order_bill_address) do
        address2.each do |key, value|
          abbr = Madison.get_abbrev address2[:state]
          value = abbr if key == :state

          expect(page).to have_content(value)
        end
      end
    end

    it 'Shipping method' do
      find('.completed', text: 'Delivery').click
      expect(page).to have_css('.active', text: 'Delivery')

      save_delivery('UPS One Day (USD)')
      save_payment(credit_card)

      expect(page).to have_css('.delivery', text: 'From default via UPS One Day (USD)')
    end
    
    it 'Payment' do
      find('.completed', text: 'Payment').click
      expect(page).to have_css('.active', text: 'Payment')

      save_payment(credit_card2)

      expect(page).to have_css('.payment-info', text: 'Ending in 2222')
    end
  end

  context 'using button' do
    it 'Billing Address' do
      find('.steps-data').all('h4 a')[0].click
      expect(page).to have_css('.active', text: 'Address')

      save_address(address2)
      save_delivery('UPS Two Day (USD)')
      save_payment(credit_card)

      order_bill_address = find('div[data-hook="order-bill-address"]')

      within(order_bill_address) do
        address2.each do |key, value|
          abbr = Madison.get_abbrev address2[:state]
          value = abbr if key == :state

          expect(page).to have_content(value)
        end
      end
    end

    it 'Shipping Address' do
      find('.steps-data').all('h4 a')[1].click
      expect(page).to have_css('.active', text: 'Address')

      save_address(address, address2)
      save_delivery('UPS Two Day (USD)')
      save_payment(credit_card)

      order_bill_address = find('div[data-hook="order-bill-address"]')
      order_ship_address = find('div[data-hook="order-ship-address"]')

      within(order_bill_address) do
        address.each do |key, value|
          abbr = Madison.get_abbrev address[:state]
          value = abbr if key == :state

          expect(page).to have_content(value)
        end
      end

      within(order_ship_address) do
        address2.each do |key, value|
          abbr = Madison.get_abbrev address2[:state]
          value = abbr if key == :state

          expect(page).to have_content(value)
        end
      end
    end

    it 'Shipping method' do
      find('.steps-data').all('h4 a')[2].click
      expect(page).to have_css('.active', text: 'Delivery')

      save_delivery('UPS One Day (USD)')
      save_payment(credit_card)

      expect(page).to have_css('.delivery', text: 'From default via UPS One Day (USD)')
    end

    it 'Payment' do
      find('.steps-data').all('h4 a')[3].click
      expect(page).to have_css('.active', text: 'Payment')

      save_payment(credit_card2)

      expect(page).to have_css('.payment-info', text: 'Ending in 2222')
    end
  end
end