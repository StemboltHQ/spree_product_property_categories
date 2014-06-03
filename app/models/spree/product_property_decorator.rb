Spree::ProductProperty.class_eval do
  has_one :product_property_category, dependent: :destroy, inverse_of: :product_property
  has_one :property_category, through: :product_property_category

  accepts_nested_attributes_for :product_property_category

  def self.measurement_units
    [
      "none",
      "inches",
      "liters",
      "meters",
      "oz"
    ]
  end

  validates :measurement_unit, inclusion: { in: Spree::ProductProperty.measurement_units }
  validates :value, numericality: true, allow_blank: true,
    if: ->(pp) { pp.measurement_unit != "none" }

  scope :uncategorized, -> do
    includes(:property_category).
      where("spree_property_categories.id is null").
      references(:property_category)
  end

  scope :displayable, -> do
    where(display: true)
  end

  def category_name
    property_category.name if property_category
  end
end
