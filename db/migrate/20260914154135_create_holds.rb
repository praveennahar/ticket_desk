class CreateHolds < ActiveRecord::Migration[8.1]
  def change
    create_table :holds do |t|
      t.references :user, null: false, foreign_key: true
      t.references :trip, null: false, foreign_key: true
      t.string :token, null: false
      t.integer :state, null: false, default: 0
      t.datetime :expires_at, null: false
      t.timestamps
    end
    add_index :holds, :token, unique: true
  end
end
