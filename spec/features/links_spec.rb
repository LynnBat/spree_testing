# frozen_string_literal: true

RSpec.feature 'links' do
  let(:router) { Router.new }

  before { visit router.root_path }

  it_behaves_like 'link leads to', 'Logo', '#logo a', ''

  it_behaves_like 'link leads to', 'Login Page', '#link-to-login', 'login'

  it_behaves_like 'link leads to', 'Cart', '.cart-info', 'cart'

  it_behaves_like 'link leads to', 'Home Page', '#home-link', ''

  scenario 'has Taxonomies links' do
    taxonomies = all('.list-group-item').collect(&:text)
    taxonomies.each do |taxonomy|
      click_link taxonomy
      title = find('.taxon-title').text

      aggregate_failures do
        expect(page.current_url).to include taxonomy.downcase
        expect(title).to eq taxonomy
      end
    end
  end
end
