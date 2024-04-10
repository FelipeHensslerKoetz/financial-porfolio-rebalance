class CreateCurrencyParityTrackers < ActiveRecord::Migration[7.1]
  def change
    create_table :currency_parity_trackers do |t|
      t.references :currency_parity, null: false, foreign_key: true
      t.decimal :exchange_rate, precision: 10, scale: 2, null: false
      t.datetime :last_sync_at, null: false
      t.references :data_origin, null: false, foreign_key: true
      t.datetime :reference_date, null: false

      t.timestamps
    end
  end
end
