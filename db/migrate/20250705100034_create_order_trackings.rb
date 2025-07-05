class CreateOrderTrackings < ActiveRecord::Migration[7.1]
  def change
    create_table :order_trackings do |t|
      t.references :order, null: false, foreign_key: true
      t.string :status
      t.text :notes

      t.timestamps
    end
  end
end
