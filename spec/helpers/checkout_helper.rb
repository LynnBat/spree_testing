module CheckoutHelper
  def add_test_products
    visit '/products/ruby-on-rails-bag'
    click_button 'Add To Cart'
    visit '/products/ruby-on-rails-tote'
    click_button 'Add To Cart'
    click_button 'Checkout'
  end

  def proceed_as_user
    find('a', text: 'Login as Existing Customer').click

    fill_in 'spree_user_email', with: ENV['USERNAME_SPREE']
    fill_in 'spree_user_password', with: ENV['PASSWORD_SPREE']

    find_button('Login').click
  end

  def proceed_as_new_user(credentials)
    fill_in 'spree_user_email', with: credentials[:email]
    fill_in 'spree_user_password', with: credentials[:password]
    fill_in 'spree_user_password_confirmation', with: credentials[:password]

    find_button('Create').click
  end

  def proceed_as_guest(credentials)
    fill_in 'order_email', with: credentials[:email]
    find_button('Continue').click
  end

  def fill_in_billing(address)
    fill_in 'order_bill_address_attributes_firstname', with: address[:first_name]
    fill_in 'order_bill_address_attributes_lastname', with: address[:last_name]
    fill_in 'order_bill_address_attributes_address1', with: address[:house_number]
    fill_in 'order_bill_address_attributes_address2', with: address[:street]
    fill_in 'order_bill_address_attributes_city', with: address[:city]
    within('#order_bill_address_attributes_state_id') { select(address[:state]) }
    fill_in 'order_bill_address_attributes_zipcode', with: address[:zip]
    fill_in 'order_bill_address_attributes_phone', with: address[:phone]
  end

  def fill_in_shipping(address)
    fill_in 'order_ship_address_attributes_firstname', with: address[:first_name]
    fill_in 'order_ship_address_attributes_lastname', with: address[:last_name]
    fill_in 'order_ship_address_attributes_address1', with: address[:house_number]
    fill_in 'order_ship_address_attributes_address2', with: address[:street]
    fill_in 'order_ship_address_attributes_city', with: address[:city]
    within('#order_ship_address_attributes_state_id') { select(address[:state]) }
    fill_in 'order_ship_address_attributes_zipcode', with: address[:zip]
    fill_in 'order_ship_address_attributes_phone', with: address[:phone]
  end

  def choose_shipping_method(shipping_method, price)
    choose(shipping_method)
    shipping_total = find('tr[data-hook="shipping_total"]').all('td')[1].text
    expect(shipping_total).to eq(price)
  end

  def fill_in_cc(card)
    fill_in 'card_number', with: card[:number]
    fill_in 'card_expiry', with: card[:expiry_date]
    fill_in 'card_code', with: card[:cvv]
  end

  def save_address(billing_address, shipping_address = nil)
    fill_in_billing(billing_address)

    if shipping_address
      uncheck 'order_use_billing'
      fill_in_shipping(shipping_address)
    end

    click_button 'Save and Continue'
  end

=begin
  def save_delivery(billing_address, shipping_address = nil)
    save_address(billing_address, shipping_address = nil)
    click_button 'Save and Continue'
  end

  def save_payment(billing_address, card, shipping_address = nil)
    save_delivery(billing_address, shipping_address = nil)
    fill_in_cc(card)
    click_button 'Save and Continue'
  end
=end

  def save_delivery(shipping_method, address = nil)
    if address
      save_address(address)
    end
    choose(shipping_method)
    click_button 'Save and Continue'
  end

  def save_payment(shipping_method, address = nil, card = nil)
    save_delivery(shipping_method, address = nil)
    fill_in_cc(card)
    click_button 'Save and Continue'
  end

  def save_payment_with_different_addresses(billing_address, shipping_address, card)
    save_address(billing_address, shipping_address)
    click_button 'Save and Continue'
    click_button 'Save and Continue'
    fill_in_cc(card)
    click_button 'Save and Continue'
  end
end