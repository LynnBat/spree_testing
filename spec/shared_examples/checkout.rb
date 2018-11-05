shared_examples 'save billing address' do |name|
  it name do
    fill_in_billing(address)

    click_button 'Save and Continue'

    expect(page).to have_css('.active', text: 'Delivery')
  end
end

shared_examples 'edit info using navigation' do |name, title|
  it name do
    find('.completed', text: title).click

    expect(page).to have_css('.active', text: title)
  end
end

shared_examples 'edit info using edit button' do |name, order_number, title|
  it name do
    find('.steps-data').all('h4 a')[order_number].click

    expect(page).to have_css('.active', text: title)
  end
end