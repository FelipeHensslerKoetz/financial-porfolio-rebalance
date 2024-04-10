class AddStatusToAssetPriceTracker < ActiveRecord::Migration[7.1]
  def change
    add_column :asset_price_trackers, :status, :string, null: false
  end
end
