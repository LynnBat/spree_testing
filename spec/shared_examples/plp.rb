# frozen_string_literal: true

shared_examples 'Filtering by' do |name|
  scenario name do
    admin_login

    case name
    when 'Categories'
      css  = '.list-group-item'
      link = '/'
    when 'Subcategories'
      css  = '.breadcrumbs'
      link = '/t/clothing'
    end

    visit link

    taxonomies = all(css).map(&:text)
    taxonomies.each do |taxonomy|
      click_on taxonomy

      sorted_products = all('span.info').map(&:text)
      sorted_products.each do |product|
        visit router.admin_products_path

        find('a', text: product).click

        taxons = find('#s2id_product_taxon_ids')
        within(taxons) { expect(page).to have_content taxonomy }
      end

      visit link
    end
  end
end
