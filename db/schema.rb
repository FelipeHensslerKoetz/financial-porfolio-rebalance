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

ActiveRecord::Schema[7.1].define(version: 2024_04_10_220517) do
  create_table "asset_prices", force: :cascade do |t|
    t.integer "asset_id", null: false
    t.integer "partner_resource_id", null: false
    t.string "code", null: false
    t.integer "currency_id", null: false
    t.decimal "price", precision: 10, scale: 2
    t.datetime "last_sync_at"
    t.datetime "reference_date"
    t.datetime "scheduled_at"
    t.string "status", null: false
    t.string "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_asset_prices_on_asset_id"
    t.index ["currency_id"], name: "index_asset_prices_on_currency_id"
    t.index ["partner_resource_id"], name: "index_asset_prices_on_partner_resource_id"
  end

  create_table "assets", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.string "business_name", null: false
    t.string "kind"
    t.string "image_path"
    t.boolean "custom", default: false, null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_assets_on_code", unique: true
    t.index ["user_id"], name: "index_assets_on_user_id"
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_currencies_on_code", unique: true
  end

  create_table "currency_parities", force: :cascade do |t|
    t.integer "currency_from_id", null: false
    t.integer "currency_to_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_from_id"], name: "index_currency_parities_on_currency_from_id"
    t.index ["currency_to_id"], name: "index_currency_parities_on_currency_to_id"
  end

  create_table "currency_parity_exchange_rates", force: :cascade do |t|
    t.integer "currency_parity_id", null: false
    t.decimal "exchange_rate", precision: 10, scale: 2, null: false
    t.datetime "last_sync_at", null: false
    t.integer "partner_resource_id", null: false
    t.datetime "reference_date", null: false
    t.string "status", null: false
    t.datetime "scheduled_at"
    t.string "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_parity_id"], name: "index_currency_parity_exchange_rates_on_currency_parity_id"
    t.index ["partner_resource_id"], name: "index_currency_parity_exchange_rates_on_partner_resource_id"
  end

  create_table "http_request_logs", force: :cascade do |t|
    t.string "request_url", null: false
    t.string "request_method", null: false
    t.json "request_headers"
    t.json "request_query_params"
    t.json "request_body"
    t.json "response_body"
    t.string "response_status_code"
    t.json "response_errors"
    t.json "response_headers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "investment_portfolio_assets", force: :cascade do |t|
    t.integer "asset_id", null: false
    t.integer "investment_portfolio_id", null: false
    t.decimal "allocation_weight", precision: 10, scale: 2, null: false
    t.decimal "quantity", precision: 10, scale: 2, null: false
    t.decimal "maximum_accepted_deviation_percentage", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_investment_portfolio_assets_on_asset_id"
    t.index ["investment_portfolio_id"], name: "index_investment_portfolio_assets_on_investment_portfolio_id"
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

  create_table "partner_resources", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "url"
    t.integer "partner_id"
    t.index ["name"], name: "index_partner_resources_on_name", unique: true
    t.index ["partner_id"], name: "index_partner_resources_on_partner_id"
  end

  create_table "partners", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_partners_on_name", unique: true
  end

  create_table "rebalance_orders", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "investment_portfolio_id", null: false
    t.string "status", null: false
    t.string "type", null: false
    t.decimal "amount"
    t.string "error_message"
    t.datetime "scheduled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["investment_portfolio_id"], name: "index_rebalance_orders_on_investment_portfolio_id"
    t.index ["user_id"], name: "index_rebalance_orders_on_user_id"
  end

  create_table "rebalances", force: :cascade do |t|
    t.integer "rebalance_order_id", null: false
    t.json "state_before_rebalance", null: false
    t.json "state_after_rebalance", null: false
    t.json "calculation_details", null: false
    t.json "recommended_actions", null: false
    t.string "status", null: false
    t.string "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rebalance_order_id"], name: "index_rebalances_on_rebalance_order_id"
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
  add_foreign_key "asset_prices", "currencies"
  add_foreign_key "asset_prices", "partner_resources"
  add_foreign_key "assets", "users"
  add_foreign_key "currency_parities", "currencies", column: "currency_from_id"
  add_foreign_key "currency_parities", "currencies", column: "currency_to_id"
  add_foreign_key "currency_parity_exchange_rates", "currency_parities"
  add_foreign_key "currency_parity_exchange_rates", "partner_resources"
  add_foreign_key "investment_portfolio_assets", "assets"
  add_foreign_key "investment_portfolio_assets", "investment_portfolios"
  add_foreign_key "investment_portfolios", "currencies"
  add_foreign_key "investment_portfolios", "users"
  add_foreign_key "partner_resources", "partners"
  add_foreign_key "rebalance_orders", "investment_portfolios"
  add_foreign_key "rebalance_orders", "users"
  add_foreign_key "rebalances", "rebalance_orders"
end
