# frozen_string_literal: true

module PLPHelper
  def get_product_price(object)
    product = object.find('.product-body').text
    price = object.find('.price.selling.lead').text.delete('$').to_f

    { product => price }
  end
end
