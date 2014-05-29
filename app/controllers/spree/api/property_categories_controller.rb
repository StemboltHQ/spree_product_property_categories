module Spree
  module Api
    class PropertyCategoriesController < Spree::Api::BaseController
      def update
        authorize! :update, Spree::PropertyCategory

        if params[:product_categories] && product = Spree::Product.find_by(slug: params[:product_id])
          Spree::PropertyCategory.transaction do
            product.product_properties.destroy_all
            params[:product_categories].values.each do |category|
              next unless category[:properties]
              category[:properties].values.each do |pp|
                next if pp[:key].blank?
                Spree::ProductProperty.create!(
                  product: product,
                  category_name: category[:name].blank? ?
                  Spree.t(:default_category_name) :
                  category[:name],
                  property_name: pp[:key],
                  value: pp[:value]
                )
              end
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
