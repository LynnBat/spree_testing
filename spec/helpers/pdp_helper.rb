module PDPHelper
  def find_picture_names(range)
    find('.thumbnails.list-inline').all('img')[range].collect { |img| img[:src].split('/').last }
  end
end