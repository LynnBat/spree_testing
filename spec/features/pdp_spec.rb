describe 'pdp' do
  before(:all) do
    login(ENV['ADMIN_SPREE'], ENV['ADMIN_PASSWORD_SPREE'])

    visit '/admin/products/ruby-on-rails-baseball-jersey/edit'
    byebug
    @title = find('#product_name').value
    @description = find('#product_description').value
    @price = find('#product_price').value

    visit '/admin/products/ruby-on-rails-baseball-jersey/variants'
    @variants = []
    table = find('.ui-sortable').all('tr')
    table.each do |variant|
      within(variant) { @variants << all('td')[1].text }
    end

    visit '/admin/products/ruby-on-rails-baseball-jersey/product_properties'
    @properties = all('.form-control').collect(&:value).reject(&:empty?)

    Capybara.reset_session!
  end

  before { visit '/products/ruby-on-rails-baseball-jersey' }

  context 'breadcrumbs' do
    it 'are present' do
      expect(page).to have_css('.breadcrumb')
    end

    xit 'redirect to the right page' do
      title = find('.breadcrumb').all('a')
      title[0].click
      expect(page.current_url).to eq "#{Capybara.app_host}/"
      page.driver.go_back

      title = find('.breadcrumb').all('a')
      link = title[1].text.downcase
      title[1].click
      expect(page.current_url).to eq "#{Capybara.app_host}/#{link}"
      page.driver.go_back

      byebug

      title = find('.breadcrumb').all('a')[2..-1]
      link = title.text.downcase
      title.click
      expect(page.current_url).to eq "#{Capybara.app_host}/t/#{link}"
      page.driver.go_back
    end
  end

  context 'picture' do
    it 'are present' do
      byebug
      # expect(page).to have_css("img[src*='ror_baseball_jersey_red.png']")
      expect(page).to have_css('.thumbnails.list-inline')
    end

    xit 'can choose different picture'
    xit 'while hovering the picture, main is changed' do
      # all('img.thumbnail').last.hover
    end
  end

  context 'properties+description' do
    it 'all info is displayed' do
      pdp_title = find('.product-title').text
      pdp_description = find('.well').text
      pdp_price = find('.lead.price.selling').text
      pdp_variants = all('.variant-description').collect(&:text)
      pdp_properties = find('#product-properties').all('td').collect(&:text)

      aggregate_failures do
        expect(pdp_title).to eq @title
        expect(pdp_description).to eq @description
        expect(pdp_price).to include @price
        expect(pdp_variants).to eq @variants
        expect(pdp_properties).to eq @properties
        expect(page).to have_css('.product-section-title', text: 'Properties')
      end
    end
  end

  context 'description block' do
    it 'can choose any variant' do
      byebug
    end
    xit 'can change the quantity: to write it, to use the arrows'
    xit 'can add to the card'
  end

  context 'similar items' do
    it 'can see the title of the block' do
      expect(page).to have_css('.product-section-title', text: 'Look for similar items')
    end

    it 'can be redirected to those items' do
      names = all('.list-group-item').collect(&:text)
      names.each do |item|
        within('#taxon-crumbs') { click_link item }
        expect(page.current_url).to eq "#{Capybara.app_host}/t/#{item.downcase}"
        go_back
      end
    end
  end
end