class CreateCrusts < ActiveRecord::Migration[7.1]
  def change
    create_table :crusts do |t|
      t.string :name
      t.integer :stock_qunantity

      t.timestamps
    end
  end
end
