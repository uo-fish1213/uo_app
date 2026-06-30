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

ActiveRecord::Schema[8.1].define(version: 2026_06_29_102512) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "families", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "family_code", null: false
    t.datetime "updated_at", null: false
    t.index ["family_code"], name: "index_families_on_family_code", unique: true
  end

  create_table "prints", force: :cascade do |t|
    t.integer "action_tag"
    t.integer "child_tag"
    t.datetime "created_at", null: false
    t.date "deadline"
    t.string "image"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_prints_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "crypted_password"
    t.string "email", null: false
    t.bigint "family_id"
    t.string "salt"
    t.datetime "updated_at", null: false
    t.string "user_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["family_id"], name: "index_users_on_family_id"
  end

  add_foreign_key "prints", "users"
  add_foreign_key "users", "families"
end
