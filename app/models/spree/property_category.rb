class Spree::PropertyCategory < ActiveRecord::Base
  has_many :product_property_categories
  has_many :product_properties, through: :product_property_categories
  has_many :products, through: :product_properties
  has_many :properties, through: :product_properties
  validates :name, presence: true

  scope :for_products, ->(product_ids) do
    joins(:products).
      where(spree_products: { id: product_ids }).
      uniq
  end
end
