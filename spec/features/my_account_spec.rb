# frozen_string_literal: true

RSpec.feature 'my_account_page' do
  before do
    @email = Faker::Internet.unique.safe_email
    @password = '1234567'

    create_user(@email, @password, @password)

    find('a', text: 'My Account').click
  end

  after { logout }

  scenario 'displays information' do
    aggregate_failures do
      expect(page).to have_css('dd', text: @email)
      store_credit = all('dd')[1].text
      expect(store_credit).to match(/\$\d+\.\d{2}/)
      expect(page).to have_css('.alert-info', text: 'You have no orders yet')
    end
  end

  # I'll finish that part after writing tests for creating orders
    xscenario 'displays orders if there are some' do
      login(email, password)

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

  describe 'editing information' do
    before { find('a', text: 'Edit').click }

    scenario 'can change the email' do
      new_email = Faker::Internet.unique.email
      fill_inputs(new_email, @password, @password)

      click_button 'Update'

      expect(page).to have_css('.alert-notice', text: 'Account updated')
    end

    scenario 'can change password' do
      new_password = 'qwerty'
      fill_inputs(@email, new_password, new_password)

      click_button 'Update'

      expect(page).to have_css('.alert-notice', text: 'Account updated')
    end

    scenario 'cant change password' do
      new_password = 'qwerty'
      fill_inputs(@email, new_password, @password)

      find_button('Update').click

      alert_text = find('.alert-danger').text
      expect(alert_text).to match "Password Confirmation doesn't match Password"
    end
  end
end
