describe 'links' do
  before { visit '/' }

  it 'has Logo link' do
    find('#logo').find('a').click
    expect(page.current_url).to eq "#{Capybara.app_host}/"
  end

  context 'header' do
    it 'has Login link' do
      find('#link-to-login').click
      expect(page.current_url).to eq "#{Capybara.app_host}/login"
    end

    it 'has Cart link' do
      find('#link-to-cart').click
      expect(page.current_url).to eq "#{Capybara.app_host}/cart"
    end

    it 'has Home link' do
      find('#home-link').click
      expect(page.current_url).to eq "#{Capybara.app_host}/"
    end
  end

  it 'has Taxonomies links' do
    all('.list-group').count.times do |taxonomy_index|
      items_amount = find_list_group_items(taxonomy_index).count
      items_amount.times do |item_index|
        list_group_item = find_list_group_items(taxonomy_index)[item_index]
        list_group_item_name = list_group_item.text.downcase
        list_group_item.click
        expect(page.current_url).to eq "#{Capybara.app_host}/t/#{list_group_item_name}"
      end
    end
  end
end