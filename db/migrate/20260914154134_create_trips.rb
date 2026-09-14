class CreateTrips < ActiveRecord::Migration[8.1]
  def change
    create_table :trips do |t|
      t.references :bus, null: false, foreign_key: true
      t.string :origin, null: false
      t.string :destination, null: false
      t.datetime :depart_at, null: false
      t.datetime :arrive_at, null: false
      t.integer :state, null: false, default: 0
      t.decimal :min_fare, precision: 10, scale: 2
      t.decimal :max_fare, precision: 10, scale: 2
      t.integer :available_seats, null: false, default: 0
      t.timestamps
    end
    add_index :trips, [:origin, :destination, :depart_at]
  end
end
