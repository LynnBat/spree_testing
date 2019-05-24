# frozen_string_literal: true

module PDPHelper
  def find_picture_names(range)
    all('.thumbnails.list-inline img')[range].map { |img| img[:src].split('/').last }
  end

  def info_from_admin_panel(selector, text = nil)
    visit Router.new.admin_item_path
    value = find(selector, text: text).text

    value = find(selector, text: text).value if value.empty?

    Capybara.reset_sessions!

    value
  end
end
