# frozen_string_literal: true

RSpec.feature 'Product Detailed Page' do
  let(:number) { rand(2...10) }
  let(:router) { Router.new }

  scenario 'has all blocks' do
    visit router.pdp_path

    aggregate_failures do
      expect(page).to have_css('.breadcrumb')
      expect(page).to have_css('#product-images')
      expect(page).to have_css('#main-image')
      expect(page).to have_css('#thumbnails')

      expect(page).to have_css('.product-section-title', text: 'Properties')
      expect(page).to have_content 'Manufacturer'
      expect(page).to have_content 'Brand'
      expect(page).to have_content 'Model'
      expect(page).to have_content 'Shirt Type'
      expect(page).to have_content 'Sleeve Type'
      expect(page).to have_content 'Made from'
      expect(page).to have_content 'Fit'
      expect(page).to have_content 'Gender'

      expect(page).to have_css('.product-title')
      expect(page).to have_css('.well[data-hook="description"]')

      expect(page).to have_css('.product-section-title', text: 'Variants')
      expect(page).to have_css('.product-section-title', text: 'Price')
      expect(page).to have_css('#quantity')
      expect(page).to have_css('#add-to-cart-button')
      expect(page).to have_css('.product-section-title', text: 'Look for similar items')
      expect(page).to have_css('#similar_items_by_taxon')
    end
  end

  describe 'All elements are present' do
    before { admin_login }

    scenario 'Breadcrumbs' do
      taxons = info_from_admin_panel('.select2-search-choice', 'Categories').split(' -> ')

      visit router.pdp_path

      pdp_taxons = find('.breadcrumb').all('a').map(&:text)[2..-1]

      expect(pdp_taxons).to eq taxons
    end

    scenario 'Product Title' do
      title = info_from_admin_panel('#product_name')

      visit router.pdp_path

      pdp_title = find('.product-title').text

      expect(pdp_title).to eq title
    end

    scenario 'Description' do
      description = info_from_admin_panel('#product_description')

      visit router.pdp_path

      pdp_description = find('.well').text

      expect(pdp_description).to eq description
    end

    scenario 'Price' do
      price = info_from_admin_panel('#product_price')

      visit router.pdp_path

      pdp_price = find('.lead.price.selling').text

      expect(pdp_price).to include price
    end

    scenario 'Pictures' do
      visit router.admin_item_pictures_path
      pictures = all('.table.sortable img').map { |img| img[:src].split('/').last }

      visit router.pdp_path

      pdp_pictures = find_picture_names(0..1)
      variants = all('.variant-description').map(&:text)

      variants.each do |variant|
        choose variant
        pdp_pictures += find_picture_names(2..3)
      end

      expect(pdp_pictures).to eq pictures
    end

    scenario 'Variants' do
      visit router.admin_item_variants_path

      variants = []
      table = find('.ui-sortable').all('tr')
      table.each do |variant|
        within(variant) { variants << all('td')[1].text }
      end

      visit router.pdp_path

      pdp_variants = all('.variant-description').map(&:text)

      expect(pdp_variants).to eq variants
    end

    scenario 'Properties' do
      visit router.admin_item_properties_path
      properties = all('.form-control').map(&:value).reject(&:empty?)

      visit router.pdp_path

      pdp_properties = all('#product-properties td').map(&:text)

      expect(pdp_properties).to eq properties
    end
  end

  describe 'Functionality' do
    before { visit router.pdp_path }

    scenario 'breadcrumbs redirect to the right page' do
      breadcrumbs = all('.breadcrumb a').map(&:text)
      breadcrumbs.each do |breadcrumb|
        find('.breadcrumb').click_on breadcrumb

        aggregate_failures do
          case breadcrumb
          when 'Home'
            expect(page).to have_current_path "#{Capybara.app_host}/"
          when 'Products'
            expect(page).to have_current_path "#{Capybara.app_host}/#{breadcrumb.downcase}"
          else
            expect(page).to have_current_path "#{Capybara.app_host}/t/#{breadcrumb.downcase}"
          end
        end

        go_back
      end
    end

    scenario 'while hovering the picture, main is changed' do
      variants = all('.variant-description').map(&:text)

      variants.each do |variant|
        choose variant

        pictures = find('.thumbnails.list-inline').all('img')

        pictures.each do |picture|
          variant_picture = picture[:src].split('/').last
          picture.hover

          main_picture = within('.text-center') { find('img')[:src].split('/').last }

          expect(variant_picture).to eq main_picture
        end
      end
    end

    scenario 'can choose any variant' do
      variants = all('.variant-description').map(&:text)

      aggregate_failures do
        variants.each do |variant|
          choose variant
          click_on 'Add To Cart'

          details = find('.cart-item-description').text
          expect(details).to include variant

          find('.delete').click

          visit router.pdp_path
        end
      end
    end

    scenario 'can change the quantity' do
      fill_in 'quantity', with: number

      click_on 'Add To Cart'

      quantity_cart = find('.line_item_quantity').value.to_i
      expect(quantity_cart).to eq number
    end

    scenario 'can add to the card' do
      click_on 'Add To Cart'

      expect(page.current_url).to include 'cart'
    end

    scenario 'can be redirected to similar items' do
      names = all('.list-group-item').map(&:text)

      aggregate_failures do
        names.each do |item|
          within('#taxon-crumbs') { click_on item }
          expect(page.current_url).to include item.downcase
          go_back
        end
      end
    end
  end
end
