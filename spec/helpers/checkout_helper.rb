# frozen_string_literal: true

module CheckoutHelper
  def add_to_cart(product)
    visit product
    click_button 'Add To Cart'
  end

  def proceed_as_new_user(credentials)
    fill_inputs(credentials.email, credentials.password, credentials.password)

    click_button 'Create'
  end

  def proceed_as_guest(credentials)
    fill_in 'order_email', with: credentials.email

    click_button 'Continue'
  end

  def fill_in_billing(address)
    fill_in 'order_bill_address_attributes_firstname', with: address.first_name
    fill_in 'order_bill_address_attributes_lastname', with: address.last_name
    fill_in 'order_bill_address_attributes_address1', with: address.house_number
    fill_in 'order_bill_address_attributes_address2', with: address.street
    fill_in 'order_bill_address_attributes_city', with: address.city
    within('#order_bill_address_attributes_state_id') { select(address.state) }
    fill_in 'order_bill_address_attributes_zipcode', with: address.zip
    fill_in 'order_bill_address_attributes_phone', with: address.phone
  end

  def fill_in_shipping(address)
    fill_in 'order_ship_address_attributes_firstname', with: address.first_name
    fill_in 'order_ship_address_attributes_lastname', with: address.last_name
    fill_in 'order_ship_address_attributes_address1', with: address.house_number
    fill_in 'order_ship_address_attributes_address2', with: address.street
    fill_in 'order_ship_address_attributes_city', with: address.city
    within('#order_ship_address_attributes_state_id') { select(address.state) }
    fill_in 'order_ship_address_attributes_zipcode', with: address.zip
    fill_in 'order_ship_address_attributes_phone', with: address.phone
  end

  def fill_in_cc(card)
    fill_in 'card_number', with: card[:number]
    fill_in 'card_expiry', with: card[:expiry_date]
    fill_in 'card_code', with: card[:cvv]
  end

  def save_address(addresses)
    fill_in_billing(addresses[:billing])

    if addresses[:shipping]
      uncheck 'order_use_billing'

      fill_in_shipping(addresses[:shipping])
    end

    click_button 'Save and Continue'
  end

  def save_delivery(shipping_method)
    choose(shipping_method)

    click_button 'Save and Continue'
  end

  def save_payment(card)
    choose('use_existing_card_no') if page.has_css?('.card_options')

    fill_in_cc(card)
    click_button 'Save and Continue'
  end
end
