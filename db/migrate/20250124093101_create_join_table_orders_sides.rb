class CreateJoinTableOrdersSides < ActiveRecord::Migration[6.1]
  def change
    create_join_table :orders, :sides do |t|
      t.index :order_id
      t.index :side_id
    end
  end
end
