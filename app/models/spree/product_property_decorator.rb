Spree::ProductProperty.class_eval do
  belongs_to :category, class_name: "Spree::PropertyCategory", inverse_of: :product_properties
end
