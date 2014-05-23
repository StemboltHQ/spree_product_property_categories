class Spree::PropertyCategory < ActiveRecord::Base
  has_many :product_properties, inverse_of: :category, foreign_key: "category_id"
  validates :name, presence: true

  scope :for_product, ->(product) do
    joins(product_properties: :product).where(spree_products: { id: product.id }).uniq
  end
end
