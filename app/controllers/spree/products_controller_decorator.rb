Spree::ProductsController.class_eval do
  before_filter :set_categories, only: :show

  protected

  def set_categories
    @categories = Spree::PropertyCategory.for_product(@product)
  end
end
