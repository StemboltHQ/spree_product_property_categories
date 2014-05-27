class @PropertyEditPage
  constructor: (@node) ->
    @category_editors = []

    this.fetchCategories()

    @node.on 'click', 'button', =>
      this.addCategory({name: 'New Category'})

    @node.on 'deleteCategory', (ev, category) =>
      this.categoryDeleted(category)

  categoryDeleted: (category) ->
    category.node.remove()
    @categories = @category.filter (c) -> c isnt category

  fetchCategories: ->
    this.addCategory { name: 'Lols and stuff' }
    this.addCategory { name: 'More Stuff' }

  addCategory: (category) ->
    @category_editors.push new CategoryEditor(@node, category)

class CategoryEditor
  constructor: (@parent, @category) ->
    @properties = []

    categoryEditorTemplate = _.template($("#category-editor-template").html())
    @node = $("<div></div>").html(categoryEditorTemplate(category_editor: this))
    @parent.append @node

    @delete_button = @node.find '.deleteCategory'
    @add_property_button = @node.find '.addProperty'
    @property_rows = @node.find 'tbody'

    @property_rows.on 'deleteProperty', (ev, property) =>
      this.propertyDeleted(property)

    @add_property_button.click =>
      @properties.push new ProductPropertyEditor(this, @property_rows, {
        key: '', value: ''})

    @delete_button.click =>
      @parent.trigger 'deleteCategory', this

  propertyDeleted: (property) ->
    property.node.remove()
    @properties = @properties.filter (p) -> p isnt property

class ProductPropertyEditor
  constructor: (@category_editor, @parent, @property) ->
    propertyEditorTemplate = _.template($("#property-editor-template").html())
    @node = $("<tr></tr>").html(propertyEditorTemplate(property_editor: this))
    @parent.append @node

    @delete_button = @node.find '.delete-property'

    @delete_button.click =>
      @parent.trigger 'deleteProperty', this
