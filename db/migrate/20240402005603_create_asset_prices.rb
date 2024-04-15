class CreateAssetPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :asset_prices do |t|
      t.references :asset, null: false, foreign_key: true
      t.references :data_origin, null: false, foreign_key: true
      t.string :code, null: false
      t.references :currency, null: false, foreign_key: true
      t.decimal :price, precision: 10, scale: 2
      t.datetime :last_sync_at
      t.datetime :reference_date
      t.string :status, null: false
      t.string :error_message

      t.timestamps
    end
  end
end
