module ShoppingCartHelper
  def find_line_item_description(taxonomy_number)
    all('.cart-item-description')[taxonomy_number].all('.line-item-description')
  end
end