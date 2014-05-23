Spree::ProductProperty.class_eval do
  belongs_to :category, class_name: "Spree::PropertyCategory", inverse_of: :product_properties

  scope :for_category, ->(category) do
    where(category_id: category.id)
  end

  def category_name=(name)
    unless name.blank?
      self.category = Spree::PropertyCategory.find_or_create_by(name: name)
    end
  end

  def category_name
    category.name if category
  end
end