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
end