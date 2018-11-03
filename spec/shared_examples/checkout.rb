shared_examples 'save billing address' do |name|
  it name do
    fill_in_billing(address)

    click_button 'Save and Continue'

    expect(page).to have_css('.active', text: 'Delivery')
  end
end