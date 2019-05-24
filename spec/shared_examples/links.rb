# frozen_string_literal: true

shared_examples 'link redirects to' do |name|
  scenario name do
    case name
    when 'Logo'
      css  = '#logo a'
      link = '/'
    when 'Login Page'
      css  = '#link-to-login'
      link = '/login'
    when 'Cart'
      css  = '.cart-info'
      link = '/cart'
    when 'Home Page'
      css  = '#home-link'
      link = '/'
    end

    find(css).click

    expect(page).to have_current_path link
  end
end
