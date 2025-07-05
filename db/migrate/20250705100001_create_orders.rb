class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :laundromat, null: false, foreign_key: true
      t.datetime :pickup_time
      t.datetime :delivery_time
      t.string :status
      t.decimal :total_price

      t.timestamps
    end
  end
end
