shared_examples 'default country' do |name|
  it name do
    uncheck 'order_use_billing'

    aggregate_failures do
      expect(page).to have_css('#order_bill_address_attributes_country_id', text: 'United States of America')
      expect(page).to have_css('#order_ship_address_attributes_country_id', text: 'United States of America')
    end
  end
end

shared_examples 'save address' do |name|
  it name do
    fill_in_billing(address)

    if name.include?('Shipping')
      uncheck 'order_use_billing'
      fill_in_shipping(address2)
    end

    click_button 'Save and Continue'

    expect(page).to have_css('.active', text: 'Delivery')
  end
end

shared_examples 'has all needed info' do |name|
  it name do
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
end

shared_examples 'shipping methods' do |name|
  it name do
    choose_shipping_method('UPS Two Day (USD)', '$10.00')
    choose_shipping_method('UPS One Day (USD)', '$15.00')
    choose_shipping_method('UPS Ground (USD)', '$5.00')
  end
end

shared_examples 'credit card' do |name|
  it name do
    fill_in_cc(credit_card)

    click_button 'Save and Continue'

    expect(page).to have_css('.active', text: 'Confirm')
  end
end

shared_examples 'payment via check' do |name|
  it name do
    choose('order_payments_attributes__payment_method_id_2')

    click_button 'Save and Continue'

    expect(page).to have_css('.alert-notice', text: 'Your order has been processed successfully')
  end
end

shared_examples 'promocode' do |name|
  it name do
    fill_in_cc(credit_card)
    fill_in 'order_coupon_code', with: 'segment'

    click_button 'Save and Continue'

    expect(page).to have_css('.total', text: 'Promotion (Discount)')
  end
end

shared_examples 'edit' do |name, title, order_number = nil|
  it name do
    if name.include?('navigation')
      find('.completed', text: title).click
    end

    if name.include?('button')
      find('.steps-data').all('h4 a')[order_number].click
    end

    expect(page).to have_css('.active', text: title)

    if name.include?('Billing')
      save_payment(address2, 'UPS Two Day (USD)', credit_card)
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
      save_payment_with_different_addresses(address, address2, credit_card)
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
      save_delivery('UPS Two Day (USD)')
      byebug
    end
    if name.include?('Payment')
    end
  end
end