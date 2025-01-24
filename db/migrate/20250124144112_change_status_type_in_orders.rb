class ChangeStatusTypeInOrders < ActiveRecord::Migration[6.0]
  def up
    add_column :orders, :status_temp, :integer, default: 0, null: false

    Order.reset_column_information
    Order.find_each do |order|
      order.update_column(:status_temp, case order.status
                                        when 'pending' then 0
                                        when 'approved' then 1
                                        else 0 
                                        end)
    end

    remove_column :orders, :status

    rename_column :orders, :status_temp, :status
  end

  def down
    add_column :orders, :status_temp, :string
    Order.reset_column_information
    Order.find_each do |order|
      order.update_column(:status_temp, case order.status
                                        when 0 then 'pending'
                                        when 1 then 'approved'
                                        else 'pending' # Default to 'pending' if value is unexpected
                                        end)
    end
    remove_column :orders, :status
    rename_column :orders, :status_temp, :status
  end
end
