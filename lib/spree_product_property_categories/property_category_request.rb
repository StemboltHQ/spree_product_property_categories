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
          properties << {
            product: @product,
            category_name: category[:name].blank? ?  Spree.t(:default_category_name) : category[:name],
            property_name: pp[:key],
            value: pp[:value],
            position: i
          }
        end
      end
      properties
    end
  end
end
