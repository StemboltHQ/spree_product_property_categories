class CreateSpreeProductPropertyCategories < ActiveRecord::Migration
  def change
    create_table :spree_product_property_categories do |t|
      t.references :property_category, null: false
      t.references :product_property, null: false
      t.integer :position, default: 0, null: false
    end

    add_index :spree_product_property_categories, :property_category_id, name: "index_sppc_property_category_id"
    add_index :spree_product_property_categories, :product_property_id, name: "index_sppc_product_category_id"
  end
end
