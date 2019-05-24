# frozen_string_literal: true

RSpec.feature 'Checkout' do
  let(:user)   { User.new }
  let(:user2)  { User.new }
  let(:router) { Router.new }

  before do
    add_to_cart(router.pdp_path)
    add_to_cart(router.pdp2_path)

    click_on 'Checkout'
  end

  describe 'New Account' do
    before { proceed_as_new_user(user) }

    it_behaves_like 'Address step'

    it_behaves_like 'Delivery step'

    it_behaves_like 'Payment step'

    it_behaves_like 'Confirmation step'
  end

  describe 'Guest' do
    before { proceed_as_guest(user) }

    it_behaves_like 'Address step'

    it_behaves_like 'Delivery step'

    it_behaves_like 'Payment step'

    it_behaves_like 'Confirmation step'
  end
end
