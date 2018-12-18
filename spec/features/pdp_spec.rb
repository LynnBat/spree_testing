describe 'pdp' do
  let(:router) { Router.new }

  context 'All elements are present' do
    before do
      admin_login

      visit router.admin_item_path
      byebug

      @title = find('#product_name').value
      @description = find('#product_description').value
      @price = find('#product_price').value

      visit admin_item_variants_path
      @pictures = find('.table.sortable').all('img').collect { |img| img[:src].split('/').last }

      visit router.admin_item_variants_path
      @variants = []
      table = find('.ui-sortable').all('tr')
      table.each do |variant|
        within(variant) { @variants << all('td')[1].text }
      end

      visit router.admin_item_properties_path
      @properties = all('.form-control').collect(&:value).reject(&:empty?)

      Capybara.reset_session!

      visit router.pdp_path
    end

    it 'info' do
      pdp_title = find('.product-title').text
      pdp_description = find('.well').text
      pdp_price = find('.lead.price.selling').text
      pdp_variants = all('.variant-description').collect(&:text)
      pdp_properties = find('#product-properties').all('td').collect(&:text)

      aggregate_failures do
        expect(page).to have_css('.breadcrumb')
        expect(pdp_title).to eq @title
        expect(pdp_description).to eq @description
        expect(pdp_price).to include @price
        expect(pdp_variants).to eq @variants
        expect(pdp_properties).to eq @properties
        expect(page).to have_css('.product-section-title', text: 'Properties')
        expect(page).to have_css('.product-section-title', text: 'Variants')
        expect(page).to have_css('.product-section-title', text: 'Look for similar items')
      end
    end

    it 'pictures' do
      byebug
      pdp_pictures = find('.thumbnails.list-inline').all('img')[0..1].collect { |img| img[:src].split('/').last }
      # expect(page).to have_css("img[src*='ror_baseball_jersey_red.png']")
      # @pictures[2..-1].each
      expect(pdp_pictures).to eq @pictures
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

    xit 'can choose different picture'
    xit 'while hovering the picture, main is changed' do
      # all('img.thumbnail').last.hover
    end

    it 'can choose any variant' do
      variants = all('.variant-description').collect(&:text)

      variants.each do |variant|
        choose variant
        click_button 'Add To Cart'

        descr = find('.cart-item-description').text
        expect(descr).to include variant

        find('.delete').click

        visit router.pdp_path
      end
    end

    it 'can change the quantity' do
      quantity_pdp = rand(1..10)
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