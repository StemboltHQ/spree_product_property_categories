Spree::Product.class_eval do
  has_many :property_categories, through: :product_properties

  def sorted_property_categories
    property_categories.
      order("spree_product_property_categories.position ASC").
      uniq
  end
end
