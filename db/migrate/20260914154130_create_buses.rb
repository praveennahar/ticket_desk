class CreateBuses < ActiveRecord::Migration[8.1]
  def change
    create_table :buses do |t|
      t.references :operator, null: false, foreign_key: true
      t.string :name, null: false
      t.string :plate, null: false
      t.integer :ac_type, null: false, default: 0
      t.integer :layout_type, null: false, default: 0
      t.timestamps
    end
    add_index :buses, :plate, unique: true
  end
end
