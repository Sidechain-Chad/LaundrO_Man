class AddUsersToLaundromat < ActiveRecord::Migration[7.1]
  def change
    add_reference :laundromats, :user, null: false, foreign_key: true
    remove_reference :laundromats, :owner
  end
end
