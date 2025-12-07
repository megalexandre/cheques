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

ActiveRecord::Schema[8.1].define(version: 2025_12_06_164438) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "borderos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "data_troca", null: false
    t.decimal "juros_mensal", precision: 10, scale: 4, null: false
    t.datetime "updated_at", null: false
  end

  create_table "cheques", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "bordero_id", null: false
    t.datetime "created_at", null: false
    t.date "data_vencimento", null: false
    t.integer "dias_compensacao", null: false
    t.datetime "updated_at", null: false
    t.decimal "valor_cheque", precision: 10, scale: 2, null: false
    t.integer "valor_cheque_cents"
    t.index ["bordero_id"], name: "index_cheques_on_bordero_id"
  end

  add_foreign_key "cheques", "borderos"
end
