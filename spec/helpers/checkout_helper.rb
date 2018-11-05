module CheckoutHelper
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

  def save_address(address)
    fill_in_billing(address)
    click_button 'Save and Continue'
  end

  def save_delivery(address)
    save_address(address)
    click_button 'Save and Continue'
  end

  def save_payment(address, card)
    save_delivery(address)
    fill_in_cc(card)
    click_button 'Save and Continue'
  end
end