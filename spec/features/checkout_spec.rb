describe 'shopping_cart' do
  let(:first_name) { 'Winnie' }
  let(:last_name) { 'Pooh' }
  let(:house_number) { '1358' }
  let(:street) { 'Wilcox Avenue' }
  let(:city) { 'Los Angeles' }
  let(:zip) { '90028' }
  let(:phone) { '1357908642' }

  before do
    visit '/products/ruby-on-rails-bag'
    click_button 'Add To Cart'
    visit '/products/ruby-on-rails-tote'
    click_button 'Add To Cart'
    click_button 'Checkout'
  end

  context 'New Account' do
    before do
      fill_in 'spree_user_email', with: Faker::Internet.unique.email
      fill_in 'spree_user_password', with: ENV['PASSWORD_SPREE']
      fill_in 'spree_user_password_confirmation', with: ENV['PASSWORD_SPREE']

      find_button('Create').click
    end

    xit 'has all blocks'
    xit 'can save billing address'
    xit 'can save shipping different from billing'

    xit 'can see all line-items'
    xit 'can choose Shipping method'
    xit 'taxes are displayed'

    xit 'can save cc'
    xit 'cant use cc with wrong info'
    xit 'whats this info'
    xit 'can choose check'
    xit 'can add the promo'

    xit 'can edit billing'
    xit 'can edit shipping'
    xit 'can edit shipping method'
    xit 'can edit payment'

    xit 'can place the order'
    xit 'can see all info'
  end

  context 'Existing Account' do
    before do
      find('a', text: 'Login as Existing Customer').click

      fill_in 'spree_user_email', with: ENV['USERNAME_SPREE']
      fill_in 'spree_user_password', with: ENV['PASSWORD_SPREE']

      find_button('Login').click
    end

    xit 'has all blocks'
    xit 'can change and save billing address'
    xit 'can change and save shipping different from billing'
    xit 'stores address to my_account'
    xit 'doesnt store my address to my_account'

    xit 'can see all line-items'
    xit 'can choose Shipping method'
    xit 'taxes are displayed'

    xit 'can use stored cc'
    xit 'can save new cc'
    xit 'cant use cc with wrong info'
    xit 'whats this info'
    xit 'can choose check'
    xit 'can add the promo'

    xit 'can edit billing'
    xit 'can edit shipping'
    xit 'can edit shipping method'
    xit 'can edit payment'

    xit 'can place the order'
    xit 'can see all info'
  end

  context 'Guest' do
    before do
      fill_in 'order_email', with: ENV['USERNAME_SPREE']
      find_button('Continue').click
    end

    it 'has all blocks' do
      customer_email = find('#order_email').value

      aggregate_failures do
        expect(page).to have_css('.first', text: 'Address')
        expect(page).to have_css('.next', text: 'Delivery')
        expect(page).to have_css('li', text: 'Payment')
        expect(page).to have_css('.last', text: 'Complete')
        expect(page).to have_css('.form-group', text: 'Customer E-Mail')
        expect(customer_email).to eq ENV['USERNAME_SPREE']
        expect(page).to have_css('.panel-heading', text: 'Billing Address')
        expect(page).to have_css('.panel-heading', text: 'Shipping Address')
        expect(page).to have_css('#checkout-summary', text: 'Order Summary')

        # expect(page).to have_css('button[value="Save and Continue"]')
      end
    end

    it 'has USA as default country' do
      uncheck 'order_use_billing'

      aggregate_failures do
        expect(page).to have_css('#order_bill_address_attributes_country_id', text: 'United States of America')
        expect(page).to have_css('#order_ship_address_attributes_country_id', text: 'United States of America')
      end
    end

    it 'can save billing address' do
      fill_in 'order_bill_address_attributes_firstname', with: first_name
      fill_in 'order_bill_address_attributes_lastname', with: last_name
      fill_in 'order_bill_address_attributes_address1', with: house_number
      fill_in 'order_bill_address_attributes_address2', with: street
      fill_in 'order_bill_address_attributes_city', with: city
      within('#order_bill_address_attributes_state_id') { select('California') }
      fill_in 'order_bill_address_attributes_zipcode', with: zip
      fill_in 'order_bill_address_attributes_phone', with: phone

      click_button 'Save and Continue'

      expect(page).to have_css('.active', text: 'Delivery')
    end

    xit 'can save shipping different from billing' do
      billing address

      uncheck 'order_use_billing'

      fill_in 'order_ship_address_attributes_firstname', with: first_name
      fill_in 'order_ship_address_attributes_lastname', with: last_name
      fill_in 'order_ship_address_attributes_address1', with: house_number
      fill_in 'order_ship_address_attributes_address2', with: street
      fill_in 'order_ship_address_attributes_city', with: city
      within('#order_ship_address_attributes_state_id') { select('California') }
      fill_in 'order_ship_address_attributes_zipcode', with: zip
      fill_in 'order_ship_address_attributes_phone', with: phone

      click_button 'Save and Continue'

      expect(page).to have_css('.active', text: 'Delivery')
    end

    xit 'can see all line-items' do
      billing address

      aggregate_failures do
        expect(page).to have_css('.item-name', text: 'Ruby on Rails Bag')
        expect(page).to have_css('.item-name', text: 'Ruby on Rails Tote')
      end
    end

    xit 'have 3 shipping methods' do
      billing address

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
      end
    end

    xit 'can choose Shipping method'
    xit 'taxes are displayed'

    it 'can save cc' do
      byebug

      billing address

      Delivery

      full_name = first_name + ' ' + last_name
      name_on_card = find('#name_on_card_1').value

      expect(page).to have_css('.panel-heading', text: 'Payment Information')
      expect(name_on_card).to eq full_name

      fill_in...
    end

    xit 'cant use cc with wrong info'
    xit 'whats this info'
    xit 'can choose check'
    xit 'can add the promo'

    xit 'can edit billing'
    xit 'can edit shipping'
    xit 'can edit shipping method'
    xit 'can edit payment'

    xit 'can place the order'
    xit 'can see all info'
  end
end