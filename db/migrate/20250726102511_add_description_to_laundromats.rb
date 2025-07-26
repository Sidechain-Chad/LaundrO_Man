class AddDescriptionToLaundromats < ActiveRecord::Migration[7.1]
  def change
    add_column :laundromats, :decription, :text
  end
end
