class AddOrderIdToSides < ActiveRecord::Migration[7.1]
  def change
    add_column :sides, :order_id, :integer
  end
end
