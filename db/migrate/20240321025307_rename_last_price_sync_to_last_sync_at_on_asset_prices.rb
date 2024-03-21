class RenameLastPriceSyncToLastSyncAtOnAssetPrices < ActiveRecord::Migration[7.1]
  def change
    rename_column :asset_prices, :last_price_sync, :last_sync_at
  end
end
