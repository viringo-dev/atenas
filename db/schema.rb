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

ActiveRecord::Schema[7.1].define(version: 2024_02_01_174447) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.string "remember_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["remember_token"], name: "index_active_sessions_on_remember_token", unique: true
    t.index ["user_id"], name: "index_active_sessions_on_user_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "bids", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "user_id", null: false
    t.float "amount", null: false
    t.float "earning", null: false
    t.text "description"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id", "user_id"], name: "index_bids_on_task_id_and_user_id", unique: true
    t.index ["task_id"], name: "index_bids_on_task_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "cashouts", force: :cascade do |t|
    t.bigint "task_id"
    t.bigint "bid_id"
    t.string "phone", null: false
    t.integer "wallet", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bid_id"], name: "index_cashouts_on_bid_id"
    t.index ["task_id"], name: "index_cashouts_on_task_id"
  end

  create_table "channel_users", force: :cascade do |t|
    t.datetime "last_read_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "channel_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_channel_users_on_channel_id"
    t.index ["user_id"], name: "index_channel_users_on_user_id"
  end

  create_table "channels", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.integer "status", default: 0, null: false
    t.string "name", null: false
    t.bigint "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_channels_on_task_id"
    t.index ["uuid"], name: "index_channels_on_uuid", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.bigint "channel_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_messages_on_channel_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "resource_type", null: false
    t.integer "resource_id", null: false
    t.integer "notification_type", null: false
    t.string "path", null: false
    t.boolean "readed", default: false, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "task_id"
    t.bigint "bid_id"
    t.string "payer", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bid_id"], name: "index_payments_on_bid_id"
    t.index ["task_id"], name: "index_payments_on_task_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "rater_id"
    t.bigint "task_id"
    t.bigint "bid_id"
    t.float "value", default: 0.0, null: false
    t.text "comment"
    t.integer "rating_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bid_id"], name: "index_ratings_on_bid_id"
    t.index ["rater_id"], name: "index_ratings_on_rater_id"
    t.index ["task_id"], name: "index_ratings_on_task_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.string "name", null: false
    t.text "description", null: false
    t.float "reward", null: false
    t.integer "currency", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "deadline", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tasks_on_user_id"
    t.index ["uuid"], name: "index_tasks_on_uuid", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "surname", null: false
    t.string "slug", null: false
    t.string "email", null: false
    t.string "phone"
    t.string "phone_code", default: "51"
    t.integer "gender"
    t.date "birthdate"
    t.string "locale", default: "es"
    t.string "country"
    t.string "city"
    t.datetime "deleted_at"
    t.boolean "rgpd_accepted", default: false, null: false
    t.string "password_digest", null: false
    t.datetime "confirmed_at"
    t.float "rating", default: 0.0, null: false
    t.boolean "avo_access", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name"
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["surname"], name: "index_users_on_surname"
  end

  add_foreign_key "active_sessions", "users", on_delete: :cascade
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "ratings", "users", column: "rater_id"
end
