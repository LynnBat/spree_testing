describe 'pdp' do
  let(:router) { Router.new }

  context 'All elements are present' do
    before { admin_login }

    it 'has same breadcrumbs as in Admin Panel' do
      visit router.admin_item_path
      byebug
    end

    it 'has Product title' do
      visit router.admin_item_path
      title = find('#product_name').value

      Capybara.reset_session!

      visit router.pdp_path

      pdp_title = find('.product-title').text

      expect(pdp_title).to eq title
    end

    it 'has description' do
      visit router.admin_item_path
      description = find('#product_description').value

      Capybara.reset_session!

      visit router.pdp_path

      pdp_description = find('.well').text

      expect(pdp_description).to eq description
    end

    it 'has price' do
      visit router.admin_item_path
      price = find('#product_price').value

      Capybara.reset_session!

      visit router.pdp_path

      pdp_price = find('.lead.price.selling').text

      expect(pdp_price).to include price
    end

    it 'has pictures' do
      visit router.admin_item_pictures_path
      pictures = find('.table.sortable').all('img').collect { |img| img[:src].split('/').last }

      Capybara.reset_session!

      visit router.pdp_path

      pdp_pictures = find_picture_names(0..1)
      variants = all('.variant-description').collect(&:text)

      variants.each do |variant|
        choose variant
        pdp_pictures += find_picture_names(2..3)
      end

      expect(pdp_pictures).to eq pictures
    end

    it 'has variants' do
      visit router.admin_item_variants_path
      variants = []
      table = find('.ui-sortable').all('tr')
      table.each do |variant|
        within(variant) { variants << all('td')[1].text }
      end

      Capybara.reset_session!

      visit router.pdp_path

      pdp_variants = all('.variant-description').collect(&:text)

      expect(pdp_variants).to eq variants
    end

    it 'has properties' do
      visit router.admin_item_properties_path
      properties = all('.form-control').collect(&:value).reject(&:empty?)

      Capybara.reset_session!

      visit router.pdp_path

      pdp_properties = find('#product-properties').all('td').collect(&:text)

      expect(pdp_properties).to eq properties
    end

    it 'has section titles and breadcrumbs' do
      visit router.pdp_path

      aggregate_failures do
        expect(page).to have_css('.breadcrumb')
        expect(page).to have_css('.product-section-title', text: 'Properties')
        expect(page).to have_css('.product-section-title', text: 'Variants')
        expect(page).to have_css('.product-section-title', text: 'Look for similar items')
      end
    end
  end

  context 'Functionality' do
    before { visit router.pdp_path }

    it 'breadcrumbs redirect to the right page' do
      breadcrumbs = find('.breadcrumb').all('a').collect(&:text)
      breadcrumbs.each do |breadcrumb|
        find('.breadcrumb').click_link breadcrumb

        if breadcrumb == 'Home'
          expect(page.current_url).to eq "#{Capybara.app_host}/"
        else
          expect(page.current_url).to include breadcrumb.downcase
        end

        go_back
      end
    end

    it 'while hovering the picture, main is changed' do
      variants = all('.variant-description').collect(&:text)

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

    it 'can choose any variant' do
      variants = all('.variant-description').collect(&:text)

      variants.each do |variant|
        choose variant
        click_button 'Add To Cart'

        details = find('.cart-item-description').text
        expect(details).to include variant

        find('.delete').click

        visit router.pdp_path
      end
    end

    it 'can change the quantity' do
      quantity_pdp = rand(2..10)
      fill_in 'quantity', with: quantity_pdp

      click_button 'Add To Cart'

      quantity_cart = find('.line_item_quantity').value.to_i
      expect(quantity_pdp).to eq quantity_cart
    end

    it 'can add to the card' do
      click_button 'Add To Cart'
      expect(page.current_url).to include 'cart'
    end

    it 'can be redirected to similar items' do
      names = all('.list-group-item').collect(&:text)
      names.each do |item|
        within('#taxon-crumbs') { click_link item }
        expect(page.current_url).to eq "#{Capybara.app_host}/t/#{item.downcase}"
        go_back
      end
    end
  end
end