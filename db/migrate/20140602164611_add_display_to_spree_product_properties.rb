class AddDisplayToSpreeProductProperties < ActiveRecord::Migration
  def change
    add_column :spree_product_properties, :display, :boolean, default: true, null: false
  end
end
