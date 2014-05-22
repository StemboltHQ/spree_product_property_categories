class CreateSpreePropertyCategories < ActiveRecord::Migration
  def change
    create_table :spree_property_categories do |t|
      t.string :name, null: false
    end
  end
end
