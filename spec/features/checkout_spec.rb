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
      number: '4111111111111111',
      expiry_date: '05/25',
      cvv: '2946'
    }
  end

  let(:credit_card2) do
    {
      number: '4222222222222222',
      expiry_date: '07/30',
      cvv: '2946'
    }
  end

  before do
    add_to_cart('/products/ruby-on-rails-bag')
    add_to_cart('/products/ruby-on-rails-tote')
    click_button 'Checkout'
  end

  context 'New Account' do
    before { proceed_as_new_user(credentials) }

    it_should_behave_like 'Address step'
    it_should_behave_like 'Delivery step'
    it_should_behave_like 'Payment step'
    it_should_behave_like 'Confirmation step'

    it_should_behave_like 'can edit on Confirmation step', 'Billing Address using navigation', 'Address'
    it_should_behave_like 'can edit on Confirmation step', 'Shipping method address using navigation', 'Delivery'
    it_should_behave_like 'can edit on Confirmation step', 'Payment using navigation', 'Payment'
    it_should_behave_like 'can edit on Confirmation step', 'Billing Address using button', 'Address', 0
    it_should_behave_like 'can edit on Confirmation step', 'Shipping Address using button', 'Address', 1
    it_should_behave_like 'can edit on Confirmation step', 'Shipping method using button', 'Delivery', 2
    it_should_behave_like 'can edit on Confirmation step', 'Payment using button', 'Payment', 3
  end

  context 'Guest' do
    before { proceed_as_guest(credentials) }

    it_should_behave_like 'Address step'
    it_should_behave_like 'Delivery step'
    it_should_behave_like 'Payment step'
    it_should_behave_like 'Confirmation step'

    it_should_behave_like 'can edit on Confirmation step', 'Billing Address using navigation', 'Address'
    it_should_behave_like 'can edit on Confirmation step', 'Shipping method address using navigation', 'Delivery'
    it_should_behave_like 'can edit on Confirmation step', 'Payment using navigation', 'Payment'
    it_should_behave_like 'can edit on Confirmation step', 'Billing Address using button', 'Address', 0
    it_should_behave_like 'can edit on Confirmation step', 'Shipping Address using button', 'Address', 1
    it_should_behave_like 'can edit on Confirmation step', 'Shipping method using button', 'Delivery', 2
    it_should_behave_like 'can edit on Confirmation step', 'Payment using button', 'Payment', 3
  end
end