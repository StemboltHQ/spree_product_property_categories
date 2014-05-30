class Spree::ProductPropertyCategory < ActiveRecord::Base
  belongs_to :property_category
  belongs_to :product_property

  validates :property_category, :product_property, :position, presence: true
end
