$ ->
  # This is mostly a copy of sprees .add_spree_fields handler.
  # It copies a row of the table and resets its values and appends it to the table.
  # We need to preset the category name which is why we copied it.
  $('.add-property-field').click ->
    target = $(@).data("target")
    category_name = $(@).data("category-name")
    new_table_row = $(target + ' tr:visible:last').clone()
    new_id = new Date().getTime()
    new_table_row.find("input, select").each ->
      element = $(@)
      if /category_name/.test(element.prop("id"))
        element.val(category_name)
      else
        element.val("")
      element.prop("id", element.prop("id").replace(/\d+/, new_id))
      element.prop("name", element.prop("name").replace(/\d+/, new_id))
    new_table_row.find("a").each ->
      $(@).prop('href', '#')
    $(target).prepend(new_table_row)
