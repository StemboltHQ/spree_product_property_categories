Spree::ProductsController.class_eval do
  before_filter :set_categories, only: :show

  protected

  def set_categories
    @categories = @product.sorted_property_categories
  end
end
