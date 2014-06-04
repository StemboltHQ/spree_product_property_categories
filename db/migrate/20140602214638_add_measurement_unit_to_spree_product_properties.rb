class AddMeasurementUnitToSpreeProductProperties < ActiveRecord::Migration
  def change
    add_column :spree_product_properties, :measurement_unit, :string, default: nil
  end
end
