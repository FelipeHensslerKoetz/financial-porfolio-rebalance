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

ActiveRecord::Schema[7.1].define(version: 2024_03_19_224023) do
  create_table "asset_prices", force: :cascade do |t|
    t.decimal "price", precision: 10, scale: 2, null: false
    t.string "currency", null: false
    t.datetime "last_price_sync", null: false
    t.string "identifier", null: false
    t.integer "data_origin_id", null: false
    t.integer "asset_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_asset_prices_on_asset_id"
    t.index ["data_origin_id"], name: "index_asset_prices_on_data_origin_id"
  end

  create_table "asset_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assets", force: :cascade do |t|
    t.string "name", null: false
    t.integer "asset_type_id", null: false
    t.string "sector"
    t.string "origin_country"
    t.string "image_path"
    t.boolean "custom", default: false, null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_type_id"], name: "index_assets_on_asset_type_id"
    t.index ["user_id"], name: "index_assets_on_user_id"
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currency_parities", force: :cascade do |t|
    t.integer "currency_from_id", null: false
    t.integer "currency_to_id", null: false
    t.decimal "exchange_rate", precision: 10, scale: 2, null: false
    t.datetime "last_sync_at", null: false
    t.integer "data_origin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_from_id"], name: "index_currency_parities_on_currency_from_id"
    t.index ["currency_to_id"], name: "index_currency_parities_on_currency_to_id"
    t.index ["data_origin_id"], name: "index_currency_parities_on_data_origin_id"
  end

  create_table "data_origins", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "http_request_logs", force: :cascade do |t|
    t.string "request_url", null: false
    t.string "request_method", null: false
    t.json "request_headers"
    t.json "request_query_params"
    t.json "request_body"
    t.json "response_body"
    t.string "response_status_code", null: false
    t.json "response_errors"
    t.json "response_headers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "investment_portfolios", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.string "description"
    t.string "image_path"
    t.integer "currency_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_id"], name: "index_investment_portfolios_on_currency_id"
    t.index ["user_id"], name: "index_investment_portfolios_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "asset_prices", "assets"
  add_foreign_key "asset_prices", "data_origins"
  add_foreign_key "assets", "asset_types"
  add_foreign_key "assets", "users"
  add_foreign_key "currency_parities", "currencies", column: "currency_from_id"
  add_foreign_key "currency_parities", "currencies", column: "currency_to_id"
  add_foreign_key "currency_parities", "data_origins"
  add_foreign_key "investment_portfolios", "currencies"
  add_foreign_key "investment_portfolios", "users"
end
