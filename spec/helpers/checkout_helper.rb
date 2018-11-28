module CheckoutHelper
  def add_to_cart(product)
    visit product
    click_button 'Add To Cart'
  end

  def proceed_as_user
    click_link 'Login as Existing Customer'

    # fill_inputs(ENV['USERNAME_SPREE'], ENV['PASSWORD_SPREE'])
    fill_in 'spree_user_email', with: ENV['USERNAME_SPREE']
    fill_in 'spree_user_password', with: ENV['PASSWORD_SPREE']

    click_button 'Login'
  end

  def proceed_as_new_user(credentials)
    # fill_inputs(credentials[:email], credentials[:password], credentials[:password])
    fill_in 'spree_user_email', with: credentials[:email]
    fill_in 'spree_user_password', with: credentials[:password]
    fill_in 'spree_user_password_confirmation', with: credentials[:password]

    click_button 'Create'
  end

  def proceed_as_guest(credentials)
    fill_in 'order_email', with: credentials[:email]
    click_button 'Continue'
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

  def save_delivery(shipping_method)
    choose(shipping_method)

    click_button 'Save and Continue'
  end

  def save_payment(card, address = nil)
    if address
      save_delivery(address)
    end

    fill_in_cc(card)
    click_button 'Save and Continue'
  end

  def save_payment_with_different_addresses(billing_address, shipping_address, card)
    save_address(billing_address, shipping_address)
    click_button 'Save and Continue'
    click_button 'Save and Continue'
  end

  def save_payment(card, shipping_method = nil, billing_address = nil, shipping_address = nil)
    save_delivery(shipping_method, billing_address, shipping_address) if shipping_method

    choose('use_existing_card_no') if page.has_css?('.card_options')

    fill_in_cc(card)
    click_button 'Save and Continue'
  end
end