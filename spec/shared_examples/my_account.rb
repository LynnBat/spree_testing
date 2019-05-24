# frozen_string_literal: true

shared_examples 'Changing' do |name|
  let(:new_email)    { Faker::Internet.unique.safe_email }
  let(:new_password) { 'qwerty' }

  before { find('a', text: 'Edit').click }

  scenario "#{name} is successful" do
    if name == 'email'
      fill_inputs(new_email, user.password, user.password)
    else
      fill_inputs(user.email, new_password, new_password)
    end

    click_on 'Update'

    expect(page).to have_css('.alert-notice', text: 'Account updated')
  end

  scenario "#{name} is unsuccessful" do
    if name == 'email'
      fill_inputs(new_email, new_password, user.password)
    else
      fill_inputs(user.email, new_password, user.password)
    end

    click_on 'Update'

    expect(page).to have_css('.alert-danger', text: "Password Confirmation doesn't match Password")
  end
end
