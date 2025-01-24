class AddStockToCrusts < ActiveRecord::Migration[7.1]
  def change
    add_column :crusts, :stock, :integer
  end
end
