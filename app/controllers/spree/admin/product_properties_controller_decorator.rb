Spree::Admin::ProductPropertiesController.class_eval do
  before_filter :set_categories, except: :update_positions

  protected

  def set_categories
    @categories = Spree::PropertyCategory.for_product(@product)
  end
end
