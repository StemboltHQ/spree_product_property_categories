Spree::Admin::ProductPropertiesController.class_eval do
  skip_before_filter :find_properties
  skip_before_filter :setup_property

  def index
    categories = @product.sorted_property_categories

    @data = categories.map do |cat|
      properties = cat.product_properties.where(product_id: @product.id)
      properties.map! do |property|
        {
          key: property.property_name,
          value: property.value,
          display: property.display?,
          measurement: property.measurement_unit
        }
      end

      {
        name: cat.name,
        properties: properties
      }
    end

    uncategorized = @product.product_properties.uncategorized
    if uncategorized.any?
      uncategorized.map! do |property|
        {
          key: property.property_name,
          value: property.value,
          display: property.display?,
          measurement: property.measurement_unit
        }
      end

      @data.unshift({ name: nil, properties: uncategorized })
    end
    @data = @data.to_json
  end
end
