describe 'shopping_cart' do
  let(:credentials) { Credentials.new }
  let(:address)     { Address.new }
  let(:address2)    { Address.new }

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

    it_should_behave_like 'Can edit on Confirmation step'
  end

  context 'Guest' do
    before { proceed_as_guest(credentials) }

    it_should_behave_like 'Address step'

    it_should_behave_like 'Delivery step'

    it_should_behave_like 'Payment step'

    it_should_behave_like 'Confirmation step'

    it_should_behave_like 'Can edit on Confirmation step'
  end
end