class ChangeOrderIdInSidesAllowNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :sides, :order_id, true
  end
end
