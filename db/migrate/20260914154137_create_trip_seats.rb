class CreateTripSeats < ActiveRecord::Migration[8.1]
  def change
    create_table :trip_seats do |t|
      t.references :trip, null: false, foreign_key: true
      t.references :seat, null: false, foreign_key: true
      t.decimal :fare, precision: 10, scale: 2, null: false
      t.integer :state, null: false, default: 0
      t.references :hold, null: true, foreign_key: true
      t.references :booking, null: true, foreign_key: true
      t.timestamps
    end
    add_index :trip_seats, [:trip_id, :seat_id], unique: true
  end
end
