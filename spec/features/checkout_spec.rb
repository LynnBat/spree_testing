# frozen_string_literal: true

RSpec.feature 'shopping_cart' do
  let(:credentials) { Credentials.new }
  let(:address)     { Address.new }
  let(:address2)    { Address.new }

  before do
    add_to_cart('/products/ruby-on-rails-bag')
    add_to_cart('/products/ruby-on-rails-tote')
    click_button 'Checkout'
  end

  describe 'New Account' do
    before { proceed_as_new_user(credentials) }

    it_behaves_like 'Address step'

    it_behaves_like 'Delivery step'

    it_behaves_like 'Payment step'

    it_behaves_like 'Confirmation step'

    it_behaves_like 'Can edit on Confirmation step'
  end

  describe 'Guest' do
    before { proceed_as_guest(credentials) }

    it_behaves_like 'Address step'

    it_behaves_like 'Delivery step'

    it_behaves_like 'Payment step'

    it_behaves_like 'Confirmation step'

    it_behaves_like 'Can edit on Confirmation step'
  end
end
