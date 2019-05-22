# frozen_string_literal: true

RSpec.feature 'My Account' do
  let(:user) { User.new }

  before do
    create_new_user(user)

    find('a', text: 'My Account').click
  end

  scenario 'displays information' do
    aggregate_failures do
      expect(page).to have_content 'My Account'
      expect(page).to have_css('#user-info')
      expect(page).to have_css('dd', text: user.email)
      store_credit = find('#user-info').text.split("\n").last
      expect(store_credit).to eq '$0.00'
      expect(page).to have_content 'My Orders'
      expect(page).to have_css('.alert-info', text: 'You have no orders yet')
    end
  end

  xscenario 'displays orders if there are some' do
    binding.pry
    add_to_cart('/products/ruby-on-rails-bag')
    click_on 'Checkout'

    find('a', text: 'My Account').click

    aggregate_failures do
      expect(page).to have_css('.order-number')
      expect(page).to have_css('.order-date')
      expect(page).to have_css('.order-status')
      expect(page).to have_css('.order-total')
      expect(page).to have_css('.order-payment-state')
      expect(page).to have_css('.order-shipment-state')
    end
  end

  it_behaves_like 'Changing', 'email'

  it_behaves_like 'Changing', 'password'
end
