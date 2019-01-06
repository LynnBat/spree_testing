describe 'plp' do
  let(:router) { Router.new }

  context 'starting with plp' do
    before do
      admin_login
      visit '/'
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

    it 'can sort products' do
      all('.list-group').count.times do |taxonomy_index|
        items_amount = find_list_group_items(taxonomy_index).count
        items_amount.times do |item_index|
          list_group_item = find_list_group_items(taxonomy_index)[item_index]
          list_group_item_name = list_group_item.text
          list_group_item.click

          sorted_products = all('span.info').collect(&:text)
          sorted_products.each do |product|
            visit router.admin_products_path
            find('a', text: product).click
            taxons = find('#s2id_product_taxon_ids')
            within(taxons) { expect(page).to have_content list_group_item_name }
          end

          visit '/'
        end
      end
    end

    it 'can sort by Subcategories' do
      visit router.plp_with_subcategories_path

      subcategories = all('.breadcrumbs')
      subcategories.each do |subcategory|
        taxonomy = subcategory.text
        subcategory.click

        sorted_products = all('span.info').collect(&:text)
        sorted_products.each do |product|
          visit router.admin_products_path
          find('a', text: product).click
          taxons = find('#s2id_product_taxon_ids')
          within(taxons) { expect(page).to have_content taxonomy }
        end

        visit router.plp_with_subcategories
      end
    end

    it 'can sort by Price' do
      visit router.rails_category_path

      products_prices = Hash.new

      all('.panel-default').each do |item|
        product = item.find('.product-body').text
        price = item.find('.price.selling.lead').text

        products_prices[product] = price

        # check next pages if applicable
      end
      byebug

      # pobrać all products and sort them
      # loop: click -> expect amount of items

      within('.navigation', text: 'Price Range') { @prices = all('input') }
      @prices.each do |price|
        price.click
        find('.btn-primary').click
      end
    end
  end

  context 'starting with Admin Panel' do
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

    it 'has all available products from Admin Panel' do
      quantity = all('tr[data-hook="admin_products_index_rows"]', text: 'Available').count

      visit '/'

      all('.page').count.times do
        quantity_per_page = all('.product-body').count
        quantity -= quantity_per_page

        click_link 'Next' if page.has_css?('.next_page')
      end

      expect(quantity).to eq 0
    end

    it 'can search for a product' do
      products = all('tr[data-hook="admin_products_index_rows"]', text: 'Available')
      titles = products.collect { |product| product.all('td')[3].text }

      visit '/'

      titles.each do |title|
        fill_in 'Search', with: title
        click_button 'Search'

        search_works_correctly = false

        products_titles = all('.product-body').collect(&:text)
        products_titles.each do |all_words|
          tag = all_words.split(' ')

          title_keys = title.split(' ')
          title_keys.each do |key|
            if tag == key
              search_works_correctly = true
            end
          end
        end

        search_title = find('.search-results-title').text
        expect(search_title).to include title
      end
    end
  end
end