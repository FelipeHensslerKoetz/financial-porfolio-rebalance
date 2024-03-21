class AddCurrencyIndexToAssetPrices < ActiveRecord::Migration[7.1]
  def change
    remove_column :asset_prices, :currency, :string
    add_reference :asset_prices, :currency, null: false, foreign_key: true
  end
end
