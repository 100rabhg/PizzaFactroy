class AddStockToSides < ActiveRecord::Migration[7.1]
  def change
    add_column :sides, :stock, :integer
  end
end
