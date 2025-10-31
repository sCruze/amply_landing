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

ActiveRecord::Schema[8.0].define(version: 2025_10_31_141502) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "meta_tags", force: :cascade do |t|
    t.string "attachable_type", null: false
    t.bigint "attachable_id", null: false
    t.text "title"
    t.text "description"
    t.text "keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachable_type", "attachable_id"], name: "index_meta_tags_on_attachable"
  end

  create_table "page_item_elements", force: :cascade do |t|
    t.bigint "page_item_id", null: false
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_item_id"], name: "index_page_item_elements_on_page_item_id"
  end

  create_table "page_items", force: :cascade do |t|
    t.bigint "page_id", null: false
    t.string "name"
    t.text "description"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_page_items_on_page_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "h1"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_requests", force: :cascade do |t|
    t.string "name", limit: 30
    t.string "email", limit: 100
    t.string "region", limit: 100
    t.string "application_area", limit: 150
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "page_item_elements", "page_items"
  add_foreign_key "page_items", "pages"
end
