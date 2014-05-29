require 'spree_product_property_categories/property_category_request'

module Spree
  module Api
    class PropertyCategoriesController < Spree::Api::BaseController
      def update
        authorize! :update, Spree::PropertyCategory


        if params[:product_categories] && product = Spree::Product.find_by(slug: params[:product_id])
          Spree::PropertyCategory.transaction do
            product.product_properties.destroy_all

            property_request = Spree::PropertyCategoryRequest.new(params[:product_categories], product)

            property_request.properties.each do |property|
              Spree::ProductProperty.create!(property)
            end
          end

          render text: { flash: Spree.t(:property_update_success) }.to_json
        else
          render text: { flash: Spree.t(:property_update_failure) }.to_json, status: 400
        end
      end
    end
  end
end
