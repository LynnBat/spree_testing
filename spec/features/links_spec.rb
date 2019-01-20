describe 'links' do
  before { visit '/' }

  it_should_behave_like 'link leads to', 'Logo', '#logo a', '/'

  it_should_behave_like 'link leads to', 'Login Page', '#link-to-login', '/login'

  it_should_behave_like 'link leads to', 'Cart', '.cart-info', '/cart'

  it_should_behave_like 'link leads to', 'Home Page', '#home-link', '/'

  it 'has Taxonomies links' do
    taxonomies = all('.list-group-item').collect(&:text)
    taxonomies.each do |taxonomy|
      click_link taxonomy
      title = find('.taxon-title').text

      aggregate_failures do
        expect(page.current_url).to include taxonomy.downcase
        expect(title).to eq taxonomy
      end
    end
  end
end