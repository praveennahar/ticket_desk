class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :trip, null: false, foreign_key: true
      t.references :hold, null: false, foreign_key: true, index: { unique: true }
      t.string :pnr, null: false
      t.decimal :total, precision: 10, scale: 2, null: false
      t.integer :state, null: false, default: 0
      t.decimal :refund, precision: 10, scale: 2
      t.datetime :cancelled_at
      t.bigint :rescheduled_from_id
      t.timestamps
    end
    add_index :bookings, :pnr, unique: true
    add_foreign_key :bookings, :bookings, column: :rescheduled_from_id
  end
end
