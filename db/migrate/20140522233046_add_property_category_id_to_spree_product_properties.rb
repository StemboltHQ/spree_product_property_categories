class AddPropertyCategoryIdToSpreeProductProperties < ActiveRecord::Migration
  def change
    add_column :spree_product_properties, :category_id, :integer, index: true
  end
end
