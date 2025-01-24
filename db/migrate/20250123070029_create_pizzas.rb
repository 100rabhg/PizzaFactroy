class CreatePizzas < ActiveRecord::Migration[7.1]
  def change
    create_table :pizzas do |t|
      t.string :name
      t.string :category
      t.string :size
      t.decimal :price

      t.timestamps
    end
  end
end
