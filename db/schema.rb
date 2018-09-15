# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_09_15_203617) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blood_compatibilities", force: :cascade do |t|
    t.bigint "donator_id"
    t.bigint "receiver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["donator_id"], name: "index_blood_compatibilities_on_donator_id"
    t.index ["receiver_id"], name: "index_blood_compatibilities_on_receiver_id"
  end

  create_table "blood_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "password_digest"
    t.bigint "blood_type_id"
    t.string "address"
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_donor", default: false
    t.boolean "is_recipient", default: false
    t.index ["blood_type_id"], name: "index_users_on_blood_type_id"
  end

  add_foreign_key "blood_compatibilities", "blood_types", column: "donator_id"
  add_foreign_key "blood_compatibilities", "blood_types", column: "receiver_id"
  add_foreign_key "users", "blood_types"
end
