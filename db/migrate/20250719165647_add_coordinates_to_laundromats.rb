class AddCoordinatesToLaundromats < ActiveRecord::Migration[7.1]
  def change
    add_column :laundromats, :latitude, :float
    add_column :laundromats, :longitude, :float
  end
end
