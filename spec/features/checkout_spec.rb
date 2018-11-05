describe 'shopping_cart' do
  let(:address) do
    {
      first_name: 'Winnie',
      last_name: 'Pooh',
      house_number: '1358',
      street: 'Wilcox Avenue',
      city: 'Los Angeles',
      state: 'California',
      zip: '90028',
      phone: '1357908642'
    }
  end

  let(:credit_card) do
    {
      number: '4111111111111111',
      expiry_date: '02/23',
      cvv: '2946'
    }
  end

=begin
  before(:all) do
    add_stock('/admin/products/ruby-on-rails-tote/stock', 100)
    add_stock('/admin/products/ruby-on-rails-bag/stock', 100)
  end
=end

  before do
    visit '/products/ruby-on-rails-bag'
    click_button 'Add To Cart'
    visit '/products/ruby-on-rails-tote'
    click_button 'Add To Cart'
    click_button 'Checkout'
  end

  it 'can log in with existing account' do
    find('a', text: 'Login as Existing Customer').click

    fill_in 'spree_user_email', with: ENV['USERNAME_SPREE']
    fill_in 'spree_user_password', with: ENV['PASSWORD_SPREE']

    find_button('Login').click

    expect(page).to have_css('.alert-success', text: 'Logged in successfully')
  end

  context 'New Account' do
    before do
      fill_in 'spree_user_email', with: Faker::Internet.unique.email
      fill_in 'spree_user_password', with: ENV['PASSWORD_SPREE']
      fill_in 'spree_user_password_confirmation', with: ENV['PASSWORD_SPREE']

      find_button('Create').click
    end
  end

  context 'Guest' do
    before do
      fill_in 'order_email', with: ENV['USERNAME_SPREE']
      find_button('Continue').click
    end

    describe 'Addres step' do
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
          # expect(page).to have_css('.form-buttons', text: 'Save and Continue')
        end
      end

      it 'has USA as default country' do
        uncheck 'order_use_billing'

        aggregate_failures do
          expect(page).to have_css('#order_bill_address_attributes_country_id', text: 'United States of America')
          expect(page).to have_css('#order_ship_address_attributes_country_id', text: 'United States of America')
        end
      end

      it_should_behave_like 'save billing address', 'I can save billing address'

      it 'can save shipping different from billing' do
        fill_in_billing(address)

        uncheck 'order_use_billing'

        fill_in_shipping(address)

        click_button 'Save and Continue'

        expect(page).to have_css('.active', text: 'Delivery')
      end
    end

    describe 'Delivery step' do
      before do
        fill_in_billing(address)

        click_button 'Save and Continue'
      end

      it 'can see all line-items' do
        aggregate_failures do
          expect(page).to have_css('.item-name', text: 'Ruby on Rails Bag')
          expect(page).to have_css('.item-name', text: 'Ruby on Rails Tote')
        end
      end

      it 'have 3 shipping methods' do
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

      it 'can choose Shipping method' do
        choose('UPS Two Day (USD)')
        shipping_total = find('tr[data-hook="shipping_total"]').all('td')[1].text
        expect(shipping_total).to eq('$10.00')

        choose('UPS One Day (USD)')
        shipping_total = find('tr[data-hook="shipping_total"]').all('td')[1].text
        expect(shipping_total).to eq('$15.00')
      end

      xit 'taxes are displayed' do
        taxes =  find('.total').text

        # change to regex
        expect(taxes).to eq('North America 5.0% $1.95')
      end

      it 'can save shipping step' do
        click_button 'Save and Continue'

        expect(page).to have_css('.active', text: 'Payment')
      end
    end

    describe 'Payment Step' do
      before do
        fill_in_billing(address)

        click_button 'Save and Continue'
        click_button 'Save and Continue'
      end

      it 'have correct info' do
        full_name = address[:first_name] + ' ' + address[:last_name]
        name_on_card = find('#name_on_card_1').value

        aggregate_failures do
          expect(page).to have_css('.panel-heading', text: 'Payment Information')
          expect(name_on_card).to eq full_name
          expect(page).to have_css('#cvv_link', text: "What's This?")
        end
      end

      it 'can save cc' do
        fill_in_cc(credit_card)

        click_button 'Save and Continue'

        expect(page).to have_css('.active', text: 'Confirm')
      end

      xit 'cant use cc with wrong info' do
        fill_in_cc(credit_card)

        fill_in 'card_expiry', with: '00/00'

        click_button 'Save and Continue'

        # payment is accepted - bug
      end

      it 'can choose check' do
        choose('order_payments_attributes__payment_method_id_2')

        click_button 'Save and Continue'

        expect(page).to have_css('.alert-notice', text: 'Your order has been processed successfully')
      end

      it 'can add the promo' do
        fill_in_cc(credit_card)
        fill_in 'order_coupon_code', with: 'segment'

        click_button 'Save and Continue'

        expect(page).to have_css('.total', text: 'Promotion (Discount)')
      end
    end

    describe 'Confirm Step' do
      before do
        fill_in_billing(address)

        click_button 'Save and Continue'
        click_button 'Save and Continue'

        fill_in_cc(credit_card)

        click_button 'Save and Continue'
      end

      xit 'can see all info'

      it_should_behave_like 'edit info using navigation', 'I can edit Billing Address', 'Address'
      it_should_behave_like 'edit info using navigation', 'I can edit Shipping method address', 'Delivery'
      it_should_behave_like 'edit info using navigation', 'I can edit Payment', 'Payment'

      it_should_behave_like 'edit info using edit button', 'I can edit Billing Address', 0, 'Address'
      it_should_behave_like 'edit info using edit button', 'I can edit Shipping Address', 1, 'Address'
      it_should_behave_like 'edit info using edit button', 'I can edit Shipping method address', 2, 'Delivery'
      it_should_behave_like 'edit info using edit button', 'I can edit Payment', 3, 'Payment'

      it 'can place the order' do
        click_button 'Place Order'

        expect(page).to have_css('.alert-notice', text: 'Your order has been processed successfully')
        # expect(page) button 'Back to Store'
      end
    end
  end
end