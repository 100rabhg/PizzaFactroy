class AddStockToToppings < ActiveRecord::Migration[7.1]
  def change
    add_column :toppings, :stock, :integer
  end
end
