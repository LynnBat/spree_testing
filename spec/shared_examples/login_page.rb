# frozen_string_literal: true

shared_examples "can't restore the password" do |error|
  scenario error do
    find('a', text: 'Forgot Password?').click

    fill_in 'spree_user_email', with: user.email if error == 'Email not found'

    click_on 'Reset my password'
    expect(page).to have_css('.alert-danger', text: error)
  end
end
