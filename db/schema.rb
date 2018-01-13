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

ActiveRecord::Schema.define(version: 20180218202729) do

  create_table "animals", force: :cascade do |t|
    t.text "eartag"
    t.integer "shepherd_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "birth_date"
    t.string "picture"
    t.string "sex"
    t.string "status"
    t.date "status_date"
    t.integer "dam_id"
    t.integer "sire_id"
    t.boolean "orphan", default: false
    t.index ["dam_id"], name: "index_animals_on_dam_id"
    t.index ["shepherd_id", "created_at"], name: "index_animals_on_shepherd_id_and_created_at"
    t.index ["shepherd_id"], name: "index_animals_on_shepherd_id"
    t.index ["sire_id"], name: "index_animals_on_sire_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "shepherds", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "username"
    t.index ["email"], name: "index_shepherds_on_email", unique: true
    t.index ["username"], name: "index_shepherds_on_username", unique: true
  end

  create_table "weights", force: :cascade do |t|
    t.decimal "weight"
    t.string "weight_type"
    t.date "date"
    t.integer "animal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["animal_id", "created_at"], name: "index_weights_on_animal_id_and_created_at"
    t.index ["animal_id"], name: "index_weights_on_animal_id"
  end

end
