class CreateSeats < ActiveRecord::Migration[8.1]
  def change
    create_table :seats do |t|
      t.references :bus, null: false, foreign_key: true
      t.string :number, null: false
      t.integer :row
      t.integer :kind, null: false, default: 0
      t.decimal :price, precision: 10, scale: 2, null: false
      t.timestamps
    end
    add_index :seats, [:bus_id, :number], unique: true
  end
end
