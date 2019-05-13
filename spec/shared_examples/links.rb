# frozen_string_literal: true

shared_examples 'link redirects to' do |name, css, url|
  scenario name do
    find(css).click

    expect(page).to have_current_path "/#{url}"
  end
end
