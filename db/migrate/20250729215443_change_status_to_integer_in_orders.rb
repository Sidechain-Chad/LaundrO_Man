class ChangeStatusToIntegerInOrders < ActiveRecord::Migration[7.1]
  def up
    # Step 1: Add new integer column
    add_column :orders, :status_tmp, :integer

    # Step 2: Copy data over with mapping
    Order.reset_column_information
    Order.find_each do |order|
      order.update_column(:status_tmp, {
        "unconfirmed" => 0,
        "pending" => 1,
        "delivered" => 3
      }[order.status])
    end

    # Step 3: Remove old column and rename
    remove_column :orders, :status
    rename_column :orders, :status_tmp, :status

    # Step 4: Add default if needed
    change_column_default :orders, :status, from: nil, to: 0
  end

  def down
    # Optional: implement if you need rollback
    add_column :orders, :status_string, :string
    Order.reset_column_information
    Order.find_each do |order|
      order.update_column(:status_string, {
        0 => "unconfirmed",
        1 => "pending",
        3 => "delivered"
      }[order.status])
    end
    remove_column :orders, :status
    rename_column :orders, :status_string, :status
  end
end
