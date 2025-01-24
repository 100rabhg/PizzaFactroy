class CreateOrderToppings < ActiveRecord::Migration[7.1]
  def change
    create_table :order_toppings do |t|
      t.references :order_pizza, null: false, foreign_key: true
      t.references :topping, null: false, foreign_key: true
      t.decimal :price

      t.timestamps
    end
  end
end
