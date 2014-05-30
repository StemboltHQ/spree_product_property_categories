class Spree::PropertyCategory < ActiveRecord::Base
  has_many :product_property_categories
  has_many :product_properties, through: :product_property_categories
  validates :name, presence: true

  scope :for_product, ->(product) do
    joins(product_properties: :product).where(spree_products: { id: product.id }).uniq.
      order("spree_product_property_categories.position ASC")
  end
end
