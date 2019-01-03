describe 'plp' do
  let(:router) { Router.new }

  before { visit '/' }

  it 'has all products' do
    # loop: goes to AP -> availble product, stores some info, goes to PLP and finds it there
    # if it can't find - click 'Next' and look for it again
    admin_login
    visit router.admin_products_path
    byebug
  end

  xit 'has 12 products per page' do
    # loop: goes to AP -> counts all products -> goes to plp counts products -> -all
    # if products<12 and all_products!= 0 -> błęd
  end

  it 'displays all breadcrumbs' do
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

        taxonomy_breadcrumb_present = false

        breadcrumbs.each do |breadcrumb|
          taxonomies.each do |taxonomy|
            if taxonomy == breadcrumb
              taxonomy_breadcrumb_present = true
            end
          end
        end

        aggregate_failures do
          expect(breadcrumbs).to include "Home"
          expect(breadcrumbs).to include "Products"
          expect(taxonomy_breadcrumb_present).to eq true
          expect(breadcrumbs).to include list_group_item_name
        end
      end
    end
  end

  xit 'can sort by Categories'
  xit 'can sort by Subcategories'
  xit 'can sort by Brands'
  xit 'can sort by Price'
end