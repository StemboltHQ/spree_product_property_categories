class Spree::ProductPropertyCategory < ActiveRecord::Base
  belongs_to :property_category
  belongs_to :product_property, inverse_of: :product_property_category

  validates :property_category, :product_property, :position, presence: true

  accepts_nested_attributes_for :property_category

  def autosave_associated_records_for_property_category
    self.property_category = Spree::PropertyCategory.find_or_create_by(name: property_category.name)
  end
end
