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

ActiveRecord::Schema[7.1].define(version: 2025_06_15_150406) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "alerts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "asset", null: false
    t.string "issue"
    t.string "severity"
    t.boolean "active", default: true
    t.datetime "last_detected_at"
    t.datetime "last_closed_at"
    t.string "last_closed_by"
    t.text "remediation"
    t.string "source"
    t.string "cve_list", default: [], array: true
    t.text "output"
    t.string "nessus_plugin_id"
    t.string "dc"
    t.uuid "assignee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "resurfaced", default: false
  end

  create_table "audit_logs", force: :cascade do |t|
    t.uuid "alert_id"
    t.text "event_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ip_addresses", force: :cascade do |t|
    t.string "ip"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lifetimes", force: :cascade do |t|
    t.string "source", null: false
    t.integer "alert_lifetime_days", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "username", null: false
    t.string "displayname"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
