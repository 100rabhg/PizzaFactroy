class CreateSides < ActiveRecord::Migration[7.1]
  def change
    create_table :sides do |t|
      t.string :name
      t.decimal :price
      t.integer :stock_qunantity

      t.timestamps
    end
  end
end
