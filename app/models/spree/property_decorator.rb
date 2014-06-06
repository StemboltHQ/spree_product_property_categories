Spree::Property.class_eval do
  scope :uncategorized_for_products, ->(product_ids) do
    joins(:products).
      includes(product_properties: :property_category).
      where(spree_property_categories: { id: nil }).
      where(spree_products: { id: product_ids }).
      uniq
  end

  scope :for_products, ->(product_ids) do
    joins(product_properties: :product).
      where(spree_products: { id: product_ids })
  end
end
