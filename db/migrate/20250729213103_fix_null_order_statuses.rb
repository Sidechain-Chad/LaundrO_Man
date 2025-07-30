class FixNullOrderStatuses < ActiveRecord::Migration[7.1]
  def up
    Order.where(status: nil).update_all(status: 0)
  end

  def down
    # optional: do nothing or set them back to nil if needed
  end
end
