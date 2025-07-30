class SetDefaultStatusForExistingOrders < ActiveRecord::Migration[7.1]
  def up
    Order.where(status: nil).update_all(status: 0)
  end

  def down
    # Optional: No-op
  end
end
