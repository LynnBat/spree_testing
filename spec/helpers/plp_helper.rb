module PLPHelper
  def get_product_price(item)
    product = item.find('.product-body').text
    price = item.find('.price.selling.lead').text.gsub('$', '').to_f

    { product => price }
  end
end