describe 'links' do
  before { visit '/' }

  it_should_behave_like 'link leads to', 'Logo', '#logo a', '/'

  it_should_behave_like 'link leads to', 'Login Page', '#link-to-login', '/login'

  it_should_behave_like 'link leads to', 'Cart', '.cart-info', '/cart'

  it_should_behave_like 'link leads to', 'Home Page', '#home-link', '/'

  it 'has Taxonomies links' do
    all('.list-group').count.times do |taxonomy_index|
      items_amount = find_list_group_items(taxonomy_index).count
      items_amount.times do |item_index|
        list_group_item = find_list_group_items(taxonomy_index)[item_index]
        list_group_item_name = list_group_item.text
        list_group_item.click
        title = find('.taxon-title').text

        aggregate_failures do
          expect(page.current_url).to include list_group_item_name.downcase
          expect(title).to eq list_group_item_name
        end
      end
    end
  end
end