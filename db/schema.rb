# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_17_090000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "amenities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_amenities_on_name", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.datetime "cancelled_at"
    t.datetime "created_at", null: false
    t.bigint "hold_id", null: false
    t.string "pnr", null: false
    t.decimal "refund", precision: 10, scale: 2
    t.bigint "rescheduled_from_id"
    t.integer "state", default: 0, null: false
    t.decimal "total", precision: 10, scale: 2, null: false
    t.bigint "trip_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["hold_id"], name: "index_bookings_on_hold_id", unique: true
    t.index ["pnr"], name: "index_bookings_on_pnr", unique: true
    t.index ["trip_id"], name: "index_bookings_on_trip_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "bus_amenities", force: :cascade do |t|
    t.bigint "amenity_id", null: false
    t.bigint "bus_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["amenity_id"], name: "index_bus_amenities_on_amenity_id"
    t.index ["bus_id", "amenity_id"], name: "index_bus_amenities_on_bus_id_and_amenity_id", unique: true
    t.index ["bus_id"], name: "index_bus_amenities_on_bus_id"
  end

  create_table "buses", force: :cascade do |t|
    t.integer "ac_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.integer "layout_type", default: 0, null: false
    t.string "name", null: false
    t.bigint "operator_id", null: false
    t.string "plate", null: false
    t.datetime "updated_at", null: false
    t.index ["operator_id"], name: "index_buses_on_operator_id"
    t.index ["plate"], name: "index_buses_on_plate", unique: true
  end

  create_table "holds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.integer "state", default: 0, null: false
    t.string "token", null: false
    t.bigint "trip_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["token"], name: "index_holds_on_token", unique: true
    t.index ["trip_id"], name: "index_holds_on_trip_id"
    t.index ["user_id"], name: "index_holds_on_user_id"
  end

  create_table "operators", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.decimal "rating", precision: 3, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_operators_on_name", unique: true
  end

  create_table "seats", force: :cascade do |t|
    t.bigint "bus_id", null: false
    t.datetime "created_at", null: false
    t.integer "kind", default: 0, null: false
    t.string "number", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "row"
    t.datetime "updated_at", null: false
    t.index ["bus_id", "number"], name: "index_seats_on_bus_id_and_number", unique: true
    t.index ["bus_id"], name: "index_seats_on_bus_id"
  end

  create_table "trip_seats", force: :cascade do |t|
    t.bigint "booking_id"
    t.datetime "created_at", null: false
    t.decimal "fare", precision: 10, scale: 2, null: false
    t.bigint "hold_id"
    t.bigint "seat_id", null: false
    t.integer "state", default: 0, null: false
    t.bigint "trip_id", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_trip_seats_on_booking_id"
    t.index ["hold_id"], name: "index_trip_seats_on_hold_id"
    t.index ["seat_id"], name: "index_trip_seats_on_seat_id"
    t.index ["trip_id", "seat_id"], name: "index_trip_seats_on_trip_id_and_seat_id", unique: true
    t.index ["trip_id"], name: "index_trip_seats_on_trip_id"
  end

  create_table "trips", force: :cascade do |t|
    t.datetime "arrive_at", null: false
    t.integer "available_seats", default: 0, null: false
    t.bigint "bus_id", null: false
    t.datetime "created_at", null: false
    t.datetime "depart_at", null: false
    t.string "destination", null: false
    t.decimal "max_fare", precision: 10, scale: 2
    t.decimal "min_fare", precision: 10, scale: 2
    t.string "origin", null: false
    t.integer "state", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["bus_id"], name: "index_trips_on_bus_id"
    t.index ["origin", "destination", "depart_at"], name: "index_trips_on_origin_and_destination_and_depart_at"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "bookings", column: "rescheduled_from_id"
  add_foreign_key "bookings", "holds"
  add_foreign_key "bookings", "trips"
  add_foreign_key "bookings", "users"
  add_foreign_key "bus_amenities", "amenities"
  add_foreign_key "bus_amenities", "buses"
  add_foreign_key "buses", "operators"
  add_foreign_key "holds", "trips"
  add_foreign_key "holds", "users"
  add_foreign_key "seats", "buses"
  add_foreign_key "trip_seats", "bookings"
  add_foreign_key "trip_seats", "holds"
  add_foreign_key "trip_seats", "seats"
  add_foreign_key "trip_seats", "trips"
  add_foreign_key "trips", "buses"
end
