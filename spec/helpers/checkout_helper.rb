# frozen_string_literal: true

module CheckoutHelper
  def add_to_cart(product)
    visit product
    click_on 'Add To Cart'
  end

  def proceed_as_new_user(user)
    fill_inputs(user.email, user.password, user.password)

    click_on 'Create'
  end

  def proceed_as_guest(user)
    fill_in 'order_email', with: user.email

    click_on 'Continue'
  end

  def fill_in_billing(user)
    fill_in 'order_bill_address_attributes_firstname', with: user.first_name
    fill_in 'order_bill_address_attributes_lastname', with: user.last_name
    fill_in 'order_bill_address_attributes_address1', with: user.house_number
    fill_in 'order_bill_address_attributes_address2', with: user.street
    fill_in 'order_bill_address_attributes_city', with: user.city
    select user.state, from: 'order_bill_address_attributes_state_id'
    fill_in 'order_bill_address_attributes_zipcode', with: user.zip
    fill_in 'order_bill_address_attributes_phone', with: user.phone
  end

  def fill_in_shipping(user)
    fill_in 'order_ship_address_attributes_firstname', with: user.first_name
    fill_in 'order_ship_address_attributes_lastname', with: user.last_name
    fill_in 'order_ship_address_attributes_address1', with: user.house_number
    fill_in 'order_ship_address_attributes_address2', with: user.street
    fill_in 'order_ship_address_attributes_city', with: user.city
    select user.state, from: 'order_ship_address_attributes_state_id'
    fill_in 'order_ship_address_attributes_zipcode', with: user.zip
    fill_in 'order_ship_address_attributes_phone', with: user.phone
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

    click_on 'Save and Continue'
  end

  def save_delivery(shipping_method = nil)
    choose(shipping_method) if shipping_method

    click_on 'Save and Continue'
  end

  def save_payment(payment = nil)
    if payment == 'Check'
      choose('use_existing_card_no') if page.has_css?('.card_options')
      choose 'Check'
    elsif payment
      choose('use_existing_card_no') if page.has_css?('.card_options')
      fill_in_cc(payment)
    end

    click_on 'Save and Continue'
  end
end
