describe 'shopping_cart' do
  let(:credentials) do
    {
      email:          Faker::Internet.unique.email,
      password:       ENV['PASSWORD_SPREE']
    }
  end

  let(:address) do
    {
      first_name:     Faker::Name.first_name,
      last_name:      Faker::Name.last_name,
      house_number:   Faker::Address.building_number,
      street:         Faker::Address.street_name,
      city:           Faker::Address.city,
      state:          Faker::Address.state,
      zip:            Faker::Address.zip,
      phone:          Faker::PhoneNumber.phone_number
    }
  end

  let(:address2) do
    {
      first_name:     Faker::Name.first_name,
      last_name:      Faker::Name.last_name,
      house_number:   Faker::Address.building_number,
      street:         Faker::Address.street_name,
      city:           Faker::Address.city,
      state:          Faker::Address.state,
      zip:            Faker::Address.zip,
      phone:          Faker::PhoneNumber.phone_number
    }
  end

  let(:credit_card) do
    {
      number:         '4111111111111111',
      expiry_date:    '05/25',
      cvv:            '2946'
    }
  end

  let(:credit_card2) do
    {
      number:         '4222222222222222',
      expiry_date:    '07/30',
      cvv:            '2946'
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

    it_should_behave_like 'can edit on Confirmation step'
  end

  context 'Guest' do
    before { proceed_as_guest(credentials) }

    it_should_behave_like 'Address step'

    it_should_behave_like 'Delivery step'

    it_should_behave_like 'Payment step'

    it_should_behave_like 'Confirmation step'

    it_should_behave_like 'can edit on Confirmation step'
  end
end