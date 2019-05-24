# frozen_string_literal: true

RSpec.feature 'Product Listed Page' do
  let(:router) { Router.new }

  scenario 'Breadcrumbs are present' do
    visit router.root_path

    taxonomies = all('.list-group-item').map(&:text)
    taxonomies.each do |taxonomy|
      click_link taxonomy
      title = find('.taxon-title').text

      breadcrumbs = find('.breadcrumb').all('a').map(&:text)
      taxonomy_title = all('.taxonomy-root').map { |taxonomy| taxonomy.text.split.last }
      title_is_present = taxonomy_title.any? { |word| breadcrumbs.include? word }

      aggregate_failures do
        expect(breadcrumbs).to include 'Home'
        expect(breadcrumbs).to include 'Products'
        expect(title_is_present).to eq true
        expect(breadcrumbs).to include title
      end
    end
  end

  it_behaves_like 'Filtering by', 'Categories'

  it_behaves_like 'Filtering by', 'Subcategories'

  scenario 'Filtering by Price' do
    admin_login

    visit router.rails_category_path

    products_prices = {}

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

    prices = find('.navigation', text: 'Price Range').all('input').map(&:value)
    prices.each do |price|
      if price.include?('under')
        max_price = price.split[1].delete('$')
        sorted_hash = products_prices.select { |_key, value| value <= max_price.to_f }
      elsif price.include?('over')
        min_price = price.split[0].delete('$')
        sorted_hash = products_prices.select { |_key, value| value >= min_price.to_f }
      else
        range = price.delete('$').delete('-').split.map(&:to_f)
        sorted_hash = products_prices.select { |_key, value| Range.new(*range).include?(value) }
      end

      check price
      find('.btn-primary').click

      aggregate_failures do
        if sorted_hash.any?
          sorted_products = all('span.info').map(&:text)

          expect(sorted_hash.keys).to eq sorted_products
        else
          expect(page).to have_css('[data-hook="products_search_results_heading"]', text: 'No products found')
        end
      end

      visit router.rails_category_path
    end
  end

  describe 'Checking info from Admin Panel' do
    before do
      admin_login
      visit router.admin_products_path
    end

    scenario 'All available products are present on PLP' do
      products = all('tr[data-hook="admin_products_index_rows"]', text: 'Available')

      pictures = products.map { |product| product.find('img')[:src].split('/').last }
      titles   = products.map { |product| product.all('td')[3].text }
      prices   = products.map { |product| product.all('td')[4].text }

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

    scenario 'can search for a product' do
      products = all('tr[data-hook="admin_products_index_rows"]', text: 'Available')
      titles = products.map { |product| product.all('td')[3].text }

      visit router.root_path

      titles.each do |title|
        fill_in 'Search', with: title
        click_button 'Search'

        products_titles = all('.product-body').map(&:text)

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
