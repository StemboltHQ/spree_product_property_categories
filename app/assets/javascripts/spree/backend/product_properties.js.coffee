class @PropertyEditPage
  constructor: (@node, payload, @product_id) ->
    @category_editors = []

    this.fetchCategories(payload)

    @node.on 'click', '.add-category', =>
      this.addCategory({name: 'New Category'})

    @node.on 'click', '.save', =>
      this.save()

    @node.on 'deleteCategory', (ev, category) =>
      this.categoryDeleted(category)

  categoryDeleted: (category) ->
    category.node.remove()
    @category_editors = @category_editors.filter (c) -> c isnt category

  fetchCategories: (payload) ->
    $.each payload, (index, item) =>
      this.addCategory(item)

  addCategory: (category) ->
    @category_editors.push new CategoryEditor(@node, category)

  save: ->
    payload = { product_id: @product_id, product_categories: this.serialize() }
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: "/api/property_categories"
      headers: 'x-spree-token': Spree.api_key
      data: payload

      success: (data) =>
        show_flash("success", data.flash)
      error: (data) =>
        if data.flash
          show_flash("error", data.flash)
        else
          show_flash("error", "There was an error updating your properties.")

  serialize: ->
    @category_editors.map (c) -> c.serialize()

class CategoryEditor
  constructor: (@parent, @category) ->
    @properties = []

    categoryEditorTemplate = _.template($("#category-editor-template").html())
    @node = $("<div></div>").html(categoryEditorTemplate(category_editor: this))
    @parent.append @node

    @delete_button = @node.find '.deleteCategory'
    @add_property_button = @node.find '.addProperty'
    @property_rows = @node.find 'tbody'

    if @category.properties
      $.each @category.properties, (index, item) =>
        this.addProperty(item)

    @property_rows.on 'deleteProperty', (ev, property) =>
      this.propertyDeleted(property)

    @add_property_button.click =>
      this.addProperty({key: '', value: ''})

    @delete_button.click =>
      @parent.trigger 'deleteCategory', this

  name: ->
    @node.find(".js-cat-name").val()

  addProperty: (property) ->
    @properties.push new ProductPropertyEditor(this, @property_rows, property)

  propertyDeleted: (property) ->
    property.node.remove()
    @properties = @properties.filter (p) -> p isnt property

  serialize: ->
    {
      name: this.name(),
      properties: @properties.map (p) -> p.serialize()
    }

class ProductPropertyEditor
  constructor: (@category_editor, @parent, @property) ->
    propertyEditorTemplate = _.template($("#property-editor-template").html())
    @node = $("<tr></tr>").html(propertyEditorTemplate(property_editor: this))
    @parent.append @node

    @delete_button = @node.find '.delete-property'

    @delete_button.click =>
      @parent.trigger 'deleteProperty', this

  key: ->
    @node.find(".js-key").val()

  value: ->
    @node.find(".js-val").val()

  serialize: ->
    { key: this.key(), value: this.value() }
