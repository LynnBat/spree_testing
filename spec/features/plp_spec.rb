describe 'plp' do
  let(:router) { Router.new }

  it 'displays all breadcrumbs' do
    visit '/'

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

  context 'Admin Panel' do
    before do
      admin_login
      visit router.admin_products_path
    end

    it 'has all products' do
      products = all('tr[data-hook="admin_products_index_rows"]', text: 'Available')

      pictures = products.collect { |product| product.find('img')[:src].split('/').last }
      titles   = products.collect { |product| product.all('td')[3].text }
      prices   = products.collect { |product| product.all('td')[4].text }

      visit '/'

      titles.each_with_index do |title, index|
        while !page.has_css?('.panel-default', text: title) do
          click_link 'Next'
        end

        pdp_product = find('.panel-default', text: title)
        pdp_picture = pdp_product.find('img')[:src].split('/').last

        aggregate_failures do
          expect(pdp_product.text).to include prices[index]
          expect(pdp_picture).to eq pictures[index]
        end

        visit '/'
      end
    end

    xit 'has 12 products per page' do
    # loop: goes to AP -> counts all products -> goes to plp counts products -> -all
    # if products<12 and all_products!= 0 -> błęd
    end

    xit 'can sort by Categories'
    xit 'can sort by Subcategories'
    xit 'can sort by Brands'
    xit 'can sort by Price'
  end
end