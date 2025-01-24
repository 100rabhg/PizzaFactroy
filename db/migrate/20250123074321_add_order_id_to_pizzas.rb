class AddOrderIdToPizzas < ActiveRecord::Migration[7.1]
  def change
    add_column :pizzas, :order_id, :integer
  end
end
