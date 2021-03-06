class @PropertyEditPage
  constructor: (@node, payload, @product_id) ->
    @category_editors = []
    @category_engine = new PropertyCategoryTypeahead
    @property_engine = new PropertyTypeahead

    @fetchCategories(payload)

    @node.on 'click', '.add-category', =>
      @addCategory({name: 'New Category'})

    @node.on 'click', '.save', =>
      return unless @validForm()
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

  validForm: =>
    category_names = _.map @category_editors, (category) ->
      category.name()
    if _.contains(category_names, "")
      show_flash 'error', 'Your categories must have non blank names.'
      return false
    else
      return true

  fetchCategories: (payload) ->
    # if there isn't an uncategorized category, add one.
    unless _.findWhere(payload, {name: null})
      payload.unshift({name: null, properties: []})

    $.each payload, (index, item) =>
      @addCategory(item)

  addCategory: (category) ->
    if category.name != null
      category_editor = new CategoryEditor(@node, category, @property_engine)
      @category_engine.addNode category_editor.node.find(".typeahead.js-cat-name")
    else
      category_editor = new DefaultCategoryEditor(@node, category, @property_engine)

    @category_editors.push category_editor

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
        if flash = data.responseJSON.flash
          show_flash('error', flash)
        else
          show_flash('error', 'There was an error updating your properties.')

  serialize: ->
    @category_editors.map (c) -> c.serialize()

class CategoryEditor
  constructor: (@parent, @category, @property_engine) ->
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
      @addProperty({measurement: null, display: true, key: '', value: ''})

    @delete_button.click =>
      @parent.trigger 'deleteCategory', this

  name: ->
    @node.find('.js-cat-name.tt-input').typeahead('val')

  addProperty: (property) ->
    property_editor = new ProductPropertyEditor(this, @property_rows, property)
    @property_engine.addNode property_editor.node.find(".typeahead.js-key")
    @properties.push property_editor

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

class DefaultCategoryEditor extends CategoryEditor
  constructor: (@parent, @category, @property_engine) ->
    super(@parent, @category, @property_engine)

    category_name = @node.find('.js-cat-name')
    category_name.prop({disabled: true, placeholder: 'uncategorized'})
  name: ->
    null

class ProductPropertyEditor
  constructor: (@category_editor, @parent, @property) ->
    propertyEditorTemplate = _.template($('#property-editor-template').html())
    @node = $('<tr>').html(propertyEditorTemplate(property_editor: this))
    @node.find("option:contains('#{@property.measurement}')").prop('selected', true)
    @parent.append @node

    @delete_button = @node.find '.js-delete-property'

    @delete_button.click =>
      @parent.trigger 'deleteProperty', this

  key: ->
    @node.find('.js-key.tt-input').typeahead('val')

  value: ->
    @node.find('.js-val').val()

  display: ->
    if @node.find(".js-display").is(":checked") then "1" else "0"

  measurement: ->
    @node.find(".js-measurement").val()

  serialize: ->
    { key: @key(), value: @value(), display: @display(), measurement: @measurement() }

class PropertyTypeahead
  constructor: ->
    @nodes = []
    @engine = new Bloodhound @engineParams()

    @engine.initialize()

  engineFilter: (response) ->
    response.properties

  engineParams: ->
    {
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      prefetch: {
        url: "/api/properties.json"
        filter: @engineFilter
      },
      remote: {
        url:"/api/properties.json?q%5Bname_cont%5D=%QUERY",
        filter: @engineFilter
        rateLimitBy: "debounce",
        rateLimitWait: 500
      },
      dupDetector: (datum1, datum2) ->
        datum1.name == datum2.name
    }

  name: ->
    "properties"
  displayKey: ->
    "name"

  addNode: (node) ->
    typeahead = node.typeahead({
      hint: true,
      highlight: true,
      minLength: 1
    },
    {
      name: @name(),
      displayKey: @displayKey(),
      source: @engine.ttAdapter()
    })
    @nodes.push typeahead
    typeahead

class PropertyCategoryTypeahead extends PropertyTypeahead
  engineParams: ->
    {
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      prefetch: {
        url: "/api/property_categories.json",
        filter: @engineFilter
      },
      remote: {
        url:"/api/property_categories.json?q%5Bname_cont%5D=%QUERY",
        rateLimitBy: "debounce",
        rateLimitWait: 500
        filter: @engineFilter
      },
      dupDetector: (datum1, datum2) ->
        datum1.name == datum2.name
    }

  name: ->
    "categories"
  engineFilter: (response) ->
    response
