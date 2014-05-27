$ ->
  # This is mostly a copy of sprees .add_spree_fields handler.
  # It copies a row of the table and resets its values and appends it to the table.
  # We need to preset the category name which is why we copied it.
  $('.add-property-field').click ->
    propertyFieldClickHandler($(@))

  $('.category_submit').click ->
    category_name = $("#new_category_field").val()
    table = document.$table = $(".category_tables").children("table").first().clone()
    # Set required attributes
    table.find("th.th-category-name").html(category_name + " Category")
    property_field = table.find("a.add-property-field")
    property_field.data("category-name", category_name)
    property_field.data("target", "tbody#product_properties_" + category_name)
    table.find("tbody").attr("id", "product_properties_" + category_name)
    table.find("tbody").children().remove()

    $(".category_tables").prepend(table)
    document.table = table
    $('body').on "click", "a.add-property-field", ->
      propertyFieldClickHandler($(@))

  propertyFieldClickHandler = ($element) ->
    target = $element.data("target")
    category_name = $element.data("category-name")
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
    console.log($(target))
    $(target).prepend(new_table_row)


