Spree::Property.class_eval do
  scope :for_products, ->(product_ids) do
    joins(:products).
      where(spree_products: { id: product_ids })
  end
end
