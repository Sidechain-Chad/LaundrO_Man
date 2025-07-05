class CreateLaundromats < ActiveRecord::Migration[7.1]
  def change
    create_table :laundromats do |t|
      t.string :name
      t.string :address
      t.string :phone_number
      t.references :owner, foreign_key: { to_table: :users }, null: true

      t.timestamps
    end
  end
end
