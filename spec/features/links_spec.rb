# frozen_string_literal: true

RSpec.feature 'links' do
  let(:router) { Router.new }

  before { visit router.root_path }

  it_behaves_like 'link redirects to', 'Logo'

  it_behaves_like 'link redirects to', 'Login Page'

  it_behaves_like 'link redirects to', 'Cart'

  it_behaves_like 'link redirects to', 'Home Page'

  scenario 'has Taxonomies links' do
    taxonomies = all('.list-group-item').map(&:text)
    taxonomies.each do |taxonomy|
      click_link taxonomy
      title = find('.taxon-title').text

      aggregate_failures do
        expect(page).to have_current_path "/t/#{taxonomy.downcase}"
        expect(title).to eq taxonomy
      end
    end
  end
end
