module LinksHelper
  def find_list_group_items(taxonomy_number)
    all('.list-group')[taxonomy_number].all('.list-group-item')
  end
end