class AddCrustIdToPizzas < ActiveRecord::Migration[7.1]
  def change
    add_column :pizzas, :crust_id, :integer
  end
end
