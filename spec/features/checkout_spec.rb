describe 'shopping_cart' do
  let(:credentials) do
    {
      email: Faker::Internet.unique.email,
      password: ENV['PASSWORD_SPREE']
    }
  end

  let(:address) do
    {
      first_name: 'Winnie',
      last_name: 'Pooh',
      house_number: '1358',
      street: 'Wilcox Avenue',
      city: 'Los Angeles',
      state: 'California',
      zip: '90028',
      phone: '123456789'
    }
  end

  let(:address2) do
    {
      first_name: 'Christopher',
      last_name: 'Robin',
      house_number: '6464',
      street: 'North Clark Street',
      city: 'Chicago',
      state: 'Illinois',
      zip: '60626',
      phone: '987654321'
    }
  end

  let(:credit_card) do
    {
      number: '4222222222222222',
      expiry_date: '05/25',
      cvv: '2946'
    }
  end

  let(:credit_card2) do
    {
      number: '4111111111111111',
      expiry_date: '07/30',
      cvv: '2946'
    }
  end

  before { add_test_products }

  it 'can log in with existing account' do
    proceed_as_user

    expect(page).to have_css('.alert-success', text: 'Logged in successfully')
  end

  context 'New Account' do
    before { proceed_as_new_user(credentials) }
  end

  context 'Guest' do
    before { proceed_as_guest(credentials) }

    describe 'Addres step' do
      it 'has all blocks' do
        byebug
        # customer_email = find('#order_email').value

        # change css
        aggregate_failures do
          expect(page).to have_css('.first', text: 'Address')
          expect(page).to have_css('.next', text: 'Delivery')
          expect(page).to have_css('li', text: 'Payment')
          expect(page).to have_css('.last', text: 'Complete')
          expect(page).to have_css('.form-group', text: 'Customer E-Mail')
          # expect(customer_email).to eq ENV['USERNAME_SPREE']
          expect(page).to have_css('.panel-heading', text: 'Billing Address')
          expect(page).to have_css('.panel-heading', text: 'Shipping Address')
          expect(page).to have_css('#checkout-summary', text: 'Order Summary')

          # expect(page).to have_css('button[value="Save and Continue"]')
          # expect(page).to have_css('.form-buttons', text: 'Save and Continue')
        end
      end

      it_should_behave_like 'default country', 'USA'
      it_should_behave_like 'save address', 'Billing'
      it_should_behave_like 'save address', 'Shipping different from Billing'
    end

    describe 'Delivery step' do
      before { save_address(address) }

      it_should_behave_like 'has all needed info', 'shipping methods, line-items'
      it_should_behave_like 'shipping methods', 'can be changed'

      xit 'taxes are displayed' do
        taxes =  find('.total').text

        # change to regex
        expect(taxes).to eq('North America 5.0% $1.95')
      end

      it 'can save delivery step' do
        click_button 'Save and Continue'

        expect(page).to have_css('.active', text: 'Payment')
      end
    end

    describe 'Payment Step' do
      before { save_delivery('UPS Two Day (USD)', address) }

      it 'have correct info' do
        full_name = address[:first_name] + ' ' + address[:last_name]
        name_on_card = find('#name_on_card_1').value

        aggregate_failures do
          expect(page).to have_css('.panel-heading', text: 'Payment Information')
          expect(name_on_card).to eq full_name
          expect(page).to have_css('#cvv_link', text: "What's This?")
        end
      end

      it_should_behave_like 'credit card', 'can be saved'
      # it_should_behave_like 'credit card', 'cant save credit card with wrong info', '00/00'
      it_should_behave_like 'payment via check', 'can pay with the check'
      it_should_behave_like 'promocode', 'can be added'
    end

    describe 'Confirm Step' do
!      before { save_payment('UPS Two Day (USD)', address, credit_card) }

      it 'can see all info' do
        byebug
      end

      # change 'edit' shared_examples
      it_should_behave_like 'edit', 'Billing Address using navigation', 'Address'
      it_should_behave_like 'edit', 'Shipping method address using navigation', 'Delivery'
      it_should_behave_like 'edit', 'Payment using navigation', 'Payment'
      it_should_behave_like 'edit', 'Billing Address using button', 'Address', 0
      it_should_behave_like 'edit', 'Shipping Address using button', 'Address', 1
      it_should_behave_like 'edit', 'Shipping method using button', 'Delivery', 2
      it_should_behave_like 'edit', 'Payment using button', 'Payment', 3

      it 'can place the order' do
        click_button 'Place Order'

        aggregate_failures do
          expect(page).to have_css('.alert-notice', text: 'Your order has been processed successfully')
          expect(page).to have_css('.button', text: 'Back to Store')
        end
      end
    end
  end
end