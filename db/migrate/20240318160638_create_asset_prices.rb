class CreateAssetPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :asset_prices do |t|
      t.decimal :price, precision: 10, scale: 2, null: false
      t.datetime :last_sync_at, null: false
      t.string :code, null: false
      t.references :data_origin, null: false, foreign_key: true
      t.references :asset, null: false, foreign_key: true
      t.references :currency, null: false, foreign_key: true

      
      t.timestamps
    end
  end
end
