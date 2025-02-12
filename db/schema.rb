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

ActiveRecord::Schema[8.0].define(version: 2025_02_12_190555) do
  create_table "gifts", force: :cascade do |t|
    t.integer "user_id"
    t.string "name", null: false
    t.string "link"
    t.integer "price"
    t.integer "wishlist_id"
    t.index ["user_id"], name: "index_gifts_on_user_id"
    t.index ["wishlist_id"], name: "index_gifts_on_wishlist_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "chat_id", null: false
    t.string "state"
    t.integer "current_wishlist_id"
    t.integer "current_gift_id"
    t.index ["chat_id"], name: "index_users_on_chat_id", unique: true
    t.index ["current_gift_id"], name: "index_users_on_current_gift_id"
    t.index ["current_wishlist_id"], name: "index_users_on_current_wishlist_id"
  end

  create_table "wishlists", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.date "event_date"
    t.index ["user_id"], name: "index_wishlists_on_user_id"
  end

  add_foreign_key "gifts", "wishlists"
  add_foreign_key "users", "gifts", column: "current_gift_id"
  add_foreign_key "users", "gifts", column: "current_gift_id"
  add_foreign_key "users", "wishlists", column: "current_wishlist_id"
  add_foreign_key "users", "wishlists", column: "current_wishlist_id"
  add_foreign_key "wishlists", "users"
end
