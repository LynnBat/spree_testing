# frozen_string_literal: true

RSpec.feature 'plp' do
  let(:router) { Router.new }

  describe 'starting with plp' do
    before do
      admin_login
      visit router.root_path
    end

    scenario 'displays all breadcrumbs' do
      taxonomies = all('.list-group-item').collect(&:text)
      taxonomies.each do |taxonomy|
        click_link taxonomy
        title = find('.taxon-title').text

        breadcrumbs = find('.breadcrumb').all('a').collect(&:text)

        taxonomy_title = all('.taxonomy-root').collect { |taxonomy| taxonomy.text.split.last }

        title_is_present = taxonomy_title.any? { |word| breadcrumbs.include? word }

        aggregate_failures do
          expect(breadcrumbs).to include 'Home'
          expect(breadcrumbs).to include 'Products'
          expect(title_is_present).to eq true
          expect(breadcrumbs).to include title
        end
      end
    end

    scenario 'can filter products by Categories' do
      taxonomies = all('.list-group-item').collect(&:text)
      taxonomies.each do |taxonomy|
        click_link taxonomy
        title = find('.taxon-title').text

        sorted_products = all('span.info').collect(&:text)
        sorted_products.each do |product|
          visit router.admin_products_path

          find('a', text: product).click

          taxons = find('#s2id_product_taxon_ids')
          within(taxons) { expect(page).to have_content taxonomy }
        end

        visit router.root_path
      end
    end

    scenario 'can filter products by Subcategories' do
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

        visit router.plp_with_subcategories_path
      end
    end

    scenario 'can filter products by Price' do
      visit router.rails_category_path

      products_prices = { }

      if page.has_css?('.page')
        all('.page').each do
          all('.panel-default').each do |item|
            products_prices.update get_product_price(item)

            click_link 'Next' if page.has_css?('.next_page')
          end
        end
      else
        all('.panel-default').each do |item|
          products_prices.update get_product_price(item)
        end
      end

      prices = find('.navigation', text: 'Price Range').all('input').collect(&:value)
      prices.each do |price|
        if price.include?('under')
          max_price = price.split[1].delete('$')
          sorted_hash = products_prices.select { |key, value| value <= max_price.to_f }
        elsif price.include?('over')
          min_price = price.split[0].delete('$')
          sorted_hash = products_prices.select { |key, value| value >= min_price.to_f }
        else
          range = price.gsub('$', '').delete('-').split.collect(&:to_f)
          sorted_hash = products_prices.select { |key, value| Range.new(*range).include?(value) }
        end

        check price
        find('.btn-primary').click

        aggregate_failures do
          if sorted_hash.any?
            sorted_products = all('span.info').collect(&:text)

            expect(sorted_hash.keys).to eq sorted_products
          else
            expect(page).to have_css('[data-hook="products_search_results_heading"]', text: 'No products found')
          end
        end

        visit router.rails_category_path
      end
    end
  end

  describe 'starting with Admin Panel' do
    before do
      admin_login
      visit router.admin_products_path
    end

    scenario 'has all products' do
      products = all('tr[data-hook="admin_products_index_rows"]', text: 'Available')

      pictures = products.collect { |product| product.find('img')[:src].split('/').last }
      titles   = products.collect { |product| product.all('td')[3].text }
      prices   = products.collect { |product| product.all('td')[4].text }

      visit router.root_path

      titles.each_with_index do |title, index|
        until page.has_css?('.panel-default', text: title)
          raise "The product #{title} is not found" unless page.has_css?('a', text: 'Next')
          click_link 'Next'
        end

        pdp_product = find('.panel-default', text: title)
        pdp_picture = pdp_product.find('img')[:src].split('/').last

        aggregate_failures do
          expect(pdp_product.text).to include prices[index]
          expect(pdp_picture).to eq pictures[index]
        end

        visit router.root_path
      end
    end

    scenario 'has all available products from Admin Panel' do
      quantity = all('tr[data-hook="admin_products_index_rows"]', text: 'Available').count

      visit router.root_path

      all('.page').count.times do
        quantity_per_page = all('.product-body').count
        quantity -= quantity_per_page

        click_link 'Next' if page.has_css?('.next_page')
      end

      expect(quantity).to eq 0
    end

    scenario 'can search for a product' do
      products = all('tr[data-hook="admin_products_index_rows"]', text: 'Available')
      titles = products.collect { |product| product.all('td')[3].text }

      visit router.root_path

      titles.each do |title|
        fill_in 'Search', with: title
        click_button 'Search'

        products_titles = all('.product-body').collect(&:text)

        products_titles.each do |all_words|
          tag = all_words.split

          title_keys = title.split
          title_keys = tag.any? { |word| title_keys.include? word }
        end

        search_title = find('.search-results-title').text
        expect(search_title).to include title
      end
    end
  end
end
