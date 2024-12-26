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

ActiveRecord::Schema[7.2].define(version: 2024_12_26_173843) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bikes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "gear_id"
    t.string "name"
    t.date "last_service_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gear_id"], name: "index_bikes_on_gear_id"
    t.index ["user_id"], name: "index_bikes_on_user_id"
  end

  create_table "service_intervals", force: :cascade do |t|
    t.bigint "bike_id", null: false
    t.string "name"
    t.integer "threshold_hours"
    t.integer "threshold_months"
    t.integer "threshold_km"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bike_id"], name: "index_service_intervals_on_bike_id"
  end

  create_table "strava_activities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "resource_state"
    t.string "name"
    t.float "distance"
    t.integer "moving_time"
    t.integer "elapsed_time"
    t.float "total_elevation_gain"
    t.string "type"
    t.string "sport_type"
    t.bigint "strava_id"
    t.datetime "start_date", precision: nil
    t.datetime "start_date_local", precision: nil
    t.string "timezone"
    t.float "utc_offset"
    t.string "location_city"
    t.string "location_state"
    t.string "location_country"
    t.string "map_id"
    t.text "map_summary_polyline"
    t.string "gear_id"
    t.string "external_id"
    t.json "raw_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["strava_id"], name: "index_strava_activities_on_strava_id"
    t.index ["user_id"], name: "index_strava_activities_on_user_id"
  end

  create_table "strava_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "token_type"
    t.integer "expires_at"
    t.integer "expires_in"
    t.string "refresh_token"
    t.string "access_token"
    t.integer "athlete_id"
    t.string "athlete_username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "expires_at"], name: "index_strava_tokens_on_user_id_and_expires_at"
    t.index ["user_id"], name: "index_strava_tokens_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.string "body"
    t.datetime "due_at"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_strava_sync_at", precision: nil
    t.date "last_service_date"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bikes", "users"
  add_foreign_key "service_intervals", "bikes"
  add_foreign_key "strava_activities", "users"
  add_foreign_key "strava_tokens", "users"
  add_foreign_key "tasks", "users"
end
