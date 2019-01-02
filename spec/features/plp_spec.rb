describe 'plp' do
  let(:router) { Router.new }

  before { visit '/' }

  it 'halo' do
    byebug
  end

  xit 'has all products' do
    # loop, goes to AP -> product, stores some info, goes to PLP and finds it there
    # if it can't find - click 'Next' and look for it again
    visit router.admin_products_path
  end

  xit 'has 12 products per page'

  it 'displays list-groop breadcrumb' do
    all('.list-group').count.times do |taxonomy_index|
      items_amount = find_list_group_items(taxonomy_index).count
      items_amount.times do |item_index|
        list_group_item = find_list_group_items(taxonomy_index)[item_index]
        list_group_item_name = list_group_item.text
        list_group_item.click

        breadcrumbs = find('.breadcrumb').all('a').collect(&:text)

        expect(breadcrumbs).to include list_group_item_name
      end
    end
  end

  it 'displays taxonomy breadcrumb' do
    all('.list-group').count.times do |taxonomy_index|
      items_amount = find_list_group_items(taxonomy_index).count
      items_amount.times do |item_index|
        list_group_item = find_list_group_items(taxonomy_index)[item_index]
        list_group_item_name = list_group_item.text
        list_group_item.click

        breadcrumbs = find('.breadcrumb').all('a').collect(&:text)

        taxonomies = all('.taxonomy-root').collect(&:text)
        taxonomies.each do |taxonomy|
          value = taxonomy.split(' ').last
          taxonomies += [value]
          taxonomies.slice!(0)
        end

        byebug
        # variable with a loop -> one element of breadcrumbs = one element taxonomies
        # expect variable = true
      end
    end
  end

  xit 'breadcrumps work'

  xit 'can sort by Categories' # done in links_spec.rb
  xit 'can sort by Subcategories'
  xit 'can sort by Brands' # done in links_spec.rb
  xit 'can sort by Price'
end