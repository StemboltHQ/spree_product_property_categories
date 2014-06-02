module Spree
  class PropertyCategoryRequest
    def initialize(params, product)
      @params = params
      @product = product
    end

    def properties
      properties = []
      @params.values.each do |category|
        next unless category[:properties]
        category[:properties].values.each_with_index do |pp, i|
          next if pp[:key].blank?
          display = (pp[:display] == "1" ? true : false)
          property = {
            product: @product,
            property_name: pp[:key],
            value: pp[:value],
            display: display,
            position: i,
            measurement_unit: pp[:measurement]
          }

          if category[:name].present?
            property.merge!({
              product_property_category_attributes: {
                position: category[:position],
                property_category_attributes: {
                  name: category[:name]
                }
              }
            })
          end
          properties << property
        end
      end
      properties
    end
  end
end
