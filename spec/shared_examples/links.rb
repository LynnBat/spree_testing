shared_examples 'link leads to' do |name, css, url|
  it name do
    find(css).click
    expect(page.current_url).to eql "#{Capybara.app_host}#{url}"
  end
end 