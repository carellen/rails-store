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

ActiveRecord::Schema.define(version: 2018_07_25_140612) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delivery_notes", force: :cascade do |t|
    t.string "customer"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "incomes", force: :cascade do |t|
    t.bigint "item_id"
    t.integer "quantity"
    t.decimal "price"
    t.bigint "receipt_note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_incomes_on_item_id"
    t.index ["receipt_note_id"], name: "index_incomes_on_receipt_note_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "outcomes", force: :cascade do |t|
    t.bigint "item_id"
    t.integer "quantity"
    t.decimal "price"
    t.bigint "delivery_note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["delivery_note_id"], name: "index_outcomes_on_delivery_note_id"
    t.index ["item_id"], name: "index_outcomes_on_item_id"
  end

  create_table "receipt_notes", force: :cascade do |t|
    t.string "supplier"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "incomes", "items"
  add_foreign_key "incomes", "receipt_notes"
  add_foreign_key "outcomes", "delivery_notes"
  add_foreign_key "outcomes", "items"
end
