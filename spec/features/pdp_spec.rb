describe 'pdp' do

  before(:all) do
    login(ENV['ADMIN_SPREE'], ENV['ADMIN_PASSWORD_SPREE'])

    visit '/admin/products/ruby-on-rails-baseball-jersey/edit'
    @title = find('#product_name').value
    @description = find('#product_description').value
    @price = find('#product_price').value

    visit '/admin/products/ruby-on-rails-baseball-jersey/variants'
    @variants = find('.ui-sortable').all('td').collect(&:value)

    visit '/admin/products/ruby-on-rails-baseball-jersey/product_properties'
    # @properties = all('.form-control').collect(&:value).reject(&:empty?)

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
    xit 'are present' do
      # expect(page).to have_css("img[src*='ror_baseball_jersey_red.png']")
      expect(page).to have_css('.thumbnails.list-inline')
    end

    xit 'can choose different picture'
    xit 'while hovering the picture, main is changed'
  end

  context 'properties+description' do
    it 'all info is displayed' do
      pdp_title = find('.product-title').text
      pdp_description = find('.well').text
      byebug
      # pdp_price = find('.lead.price.selling').text
      pdp_variants = all('.variant-description').collect(&:text)
      # pdp_properties = find('#product-properties').all('td').collect(&:text)

      aggregate_failures do
        expect(@title).to eq pdp_title
        expect(@description).to eq pdp_description
        # expect(@price).to eq pdp_price
        # expect(@variants).to eq pdp_variants
        # expect(@properties).to eq pdp_properties
        expect(page).to have_css('.product-section-title', text: 'Properties')
      end
    end
  end

  context 'description block' do
    xit 'can choose any variant'
    xit 'can see the price'
    xit 'can change the quantity: to write it, to use the arrows'
    xit 'can add to the card'
  end

  context 'similar items' do
    it 'can see the title of the block' do
      byebug
    end

    xit 'can be redirected to those items'
  end
end