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

ActiveRecord::Schema[7.1].define(version: 2025_09_25_132556) do
  create_table "characters", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conversation_choices", force: :cascade do |t|
    t.integer "conversation_id", null: false
    t.string "label", null: false
    t.integer "position", null: false
    t.integer "next_conversation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_conversation_choices_on_conversation_id"
    t.index ["next_conversation_id"], name: "index_conversation_choices_on_next_conversation_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "character_id", null: false
    t.integer "kind", null: false
    t.integer "time_slot", null: false
    t.integer "weather_slot", null: false
    t.integer "min_affinity", default: 0, null: false
    t.integer "weight", default: 1
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.index ["character_id", "kind", "time_slot", "weather_slot"], name: "idx_on_character_id_kind_time_slot_weather_slot_92acd7b900"
    t.index ["character_id"], name: "index_conversations_on_character_id"
  end

  create_table "inquiries", force: :cascade do |t|
    t.string "sender_name", null: false
    t.string "email", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interactions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "character_id", null: false
    t.integer "kind", default: 0, null: false
    t.datetime "happened_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_interactions_on_character_id"
    t.index ["user_id", "kind", "happened_at"], name: "index_interactions_on_user_id_and_kind_and_happened_at"
    t.index ["user_id"], name: "index_interactions_on_user_id"
  end

  create_table "user_characters", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "character_id", null: false
    t.integer "affinity", default: 0, null: false
    t.boolean "is_selected", default: false, null: false
    t.datetime "last_interacted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_user_characters_on_character_id"
    t.index ["user_id", "character_id"], name: "index_user_characters_on_user_id_and_character_id", unique: true
    t.index ["user_id"], name: "index_user_characters_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "guest_uid", null: false
    t.integer "auth_kind", default: 0, null: false
    t.string "nickname"
    t.string "email"
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["guest_uid"], name: "index_users_on_guest_uid", unique: true
  end

  add_foreign_key "conversation_choices", "conversations"
  add_foreign_key "conversation_choices", "conversations", column: "next_conversation_id"
  add_foreign_key "conversations", "characters"
  add_foreign_key "interactions", "characters"
  add_foreign_key "interactions", "users"
  add_foreign_key "user_characters", "characters"
  add_foreign_key "user_characters", "users"
end
