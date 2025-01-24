class CreateOrderSides < ActiveRecord::Migration[7.1]
  def change
    create_table :order_sides do |t|
      t.references :order, null: false, foreign_key: true
      t.references :side, null: false, foreign_key: true
      t.decimal :price

      t.timestamps
    end
  end
end
