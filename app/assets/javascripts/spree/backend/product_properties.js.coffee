class @PropertyEditPage
  constructor: (@node, payload, @product_id) ->
    @category_editors = []

    @fetchCategories(payload)

    @node.on 'click', '.add-category', =>
      @addCategory({name: 'New Category'})

    @node.on 'click', '.save', =>
      @save()

    @node.on 'deleteCategory', (ev, category) =>
      @categoryDeleted(category)

    @node.sortable
      handle: '.category-handle',
      placeholder: 'ui-sortable-placeholder',
      items: '.js-category-node'
      start: (event, ui) ->
        ui.placeholder.height(ui.item.height())
        ui.placeholder.html "<div style='height:#{ui.item.height()}; width:#{ui.item.width()};'></div>"


  categoryDeleted: (category) ->
    category.node.remove()
    @category_editors = @category_editors.filter (c) -> c isnt category

  fetchCategories: (payload) ->
    $.each payload, (index, item) =>
      @addCategory(item)

  addCategory: (category) ->
    @category_editors.push new CategoryEditor(@node, category)

  save: ->
    payload = { product_id: @product_id, product_categories: @serialize() }
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: '/api/property_categories'
      headers: 'x-spree-token': Spree.api_key
      data: payload

      success: (data) =>
        show_flash('success', data.flash)
      error: (data) =>
        if data.flash
          show_flash('error', data.flash)
        else
          show_flash('error', 'There was an error updating your properties.')

  serialize: ->
    @category_editors.map (c) -> c.serialize()

class CategoryEditor
  constructor: (@parent, @category) ->
    @properties = []

    categoryEditorTemplate = _.template($('#category-editor-template').html())
    @node = $("<div class='js-category-node'>").html(categoryEditorTemplate(category_editor: this))
    @parent.append @node

    @delete_button = @node.find '.js-delete-category'
    @add_property_button = @node.find '.js-add-property'
    @property_rows = @node.find 'tbody'

    @node.find('tbody').sortable
      handle: '.handle',
      update: =>
        @sortProperties()
      placeholder: 'ui-sortable-placeholder',
      start: (event, ui) =>
        ui.placeholder.height(ui.item.height())
        ui.placeholder.html "<td colspan='#{@node.find('th').length + 1}'></td><td class='actions'></td>"

    if @category.properties
      $.each @category.properties, (index, item) =>
        @addProperty(item)

    @property_rows.on 'deleteProperty', (ev, property) =>
      @propertyDeleted(property)

    @add_property_button.click =>
      @addProperty({key: '', value: ''})

    @delete_button.click =>
      @parent.trigger 'deleteCategory', this

  name: ->
    @node.find('.js-cat-name').val()

  addProperty: (property) ->
    @properties.push new ProductPropertyEditor(this, @property_rows, property)

  propertyDeleted: (property) ->
    property.node.remove()
    @properties = @properties.filter (p) -> p isnt property

  serialize: ->
    {
      name: @name(),
      position: @node.index() - 1
      properties: @properties.map (p) -> p.serialize()
    }

  sortProperties: ->
    @properties = _.sortBy @properties, (p) -> p.node.index()

class ProductPropertyEditor
  constructor: (@category_editor, @parent, @property) ->
    propertyEditorTemplate = _.template($('#property-editor-template').html())
    @node = $('<tr>').html(propertyEditorTemplate(property_editor: this))
    @parent.append @node

    @delete_button = @node.find '.js-delete-property'

    @delete_button.click =>
      @parent.trigger 'deleteProperty', this

  key: ->
    @node.find('.js-key').val()

  value: ->
    @node.find('.js-val').val()

  serialize: ->
    { key: @key(), value: @value() }
