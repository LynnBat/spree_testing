# frozen_string_literal: true

module PDPHelper
  def find_picture_names(range)
    find('.thumbnails.list-inline').all('img')[range].collect { |img| img[:src].split('/').last }
  end

  def info_from_admin_panel(selector, text = nil)
    visit router.admin_item_path
    value = find(selector, text: text).text

    value = find(selector, text: text).value if value == ''

    Capybara.reset_sessions!

    value
  end
end
