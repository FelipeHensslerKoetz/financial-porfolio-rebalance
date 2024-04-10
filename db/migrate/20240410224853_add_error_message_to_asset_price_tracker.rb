class AddErrorMessageToAssetPriceTracker < ActiveRecord::Migration[7.1]
  def change
    add_column :asset_price_trackers, :error_message, :string
  end
end
