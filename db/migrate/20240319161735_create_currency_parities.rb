class CreateCurrencyParities < ActiveRecord::Migration[7.1]
  def change
    create_table :currency_parities do |t|
      t.references :currency_from, index: true, null: false, foreign_key: { to_table: :currencies }
      t.references :currency_to, index: true, null: false, foreign_key: { to_table: :currencies }
      t.decimal :exchange_rate, null: false, precision: 10, scale: 2
      t.datetime :last_sync_at, null: false
      t.references :data_origin, index: true, null: false, foreign_key: true
      t.timestamps
    end
  end
end
