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

ActiveRecord::Schema.define(version: 2018_11_29_153508) do

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

  create_table "blood_donation_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.float "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "donor_id"
    t.bigint "recipient_id"
    t.boolean "fulfilled"
    t.index ["donor_id"], name: "index_blood_donation_requests_on_donor_id"
    t.index ["recipient_id"], name: "index_blood_donation_requests_on_recipient_id"
    t.index ["user_id"], name: "index_blood_donation_requests_on_user_id"
  end

  create_table "blood_donations", force: :cascade do |t|
    t.bigint "donor_id"
    t.bigint "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "notified"
    t.index ["donor_id"], name: "index_blood_donations_on_donor_id"
    t.index ["recipient_id"], name: "index_blood_donations_on_recipient_id"
  end

  create_table "blood_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "donation_queues", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.bigint "donor_id"
    t.bigint "recipient_id"
    t.index ["donor_id"], name: "index_donation_queues_on_donor_id"
    t.index ["recipient_id"], name: "index_donation_queues_on_recipient_id"
  end

  create_table "recipient_wait_lists", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "blood_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blood_type_id"], name: "index_recipient_wait_lists_on_blood_type_id"
    t.index ["user_id"], name: "index_recipient_wait_lists_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id"
    t.string "ip_address"
    t.string "browser"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
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
    t.integer "confirm_token"
    t.boolean "confirmed"
    t.index ["blood_type_id"], name: "index_users_on_blood_type_id"
  end

  add_foreign_key "blood_compatibilities", "blood_types", column: "donator_id"
  add_foreign_key "blood_compatibilities", "blood_types", column: "receiver_id"
  add_foreign_key "blood_donation_requests", "users"
  add_foreign_key "blood_donation_requests", "users", column: "donor_id"
  add_foreign_key "blood_donation_requests", "users", column: "recipient_id"
  add_foreign_key "blood_donations", "users", column: "donor_id"
  add_foreign_key "blood_donations", "users", column: "recipient_id"
  add_foreign_key "donation_queues", "users", column: "donor_id"
  add_foreign_key "donation_queues", "users", column: "recipient_id"
  add_foreign_key "recipient_wait_lists", "blood_types"
  add_foreign_key "recipient_wait_lists", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "users", "blood_types"
end
