class AddReferenceDateToAssetPriceTrackers < ActiveRecord::Migration[7.1]
  def change
    add_column :asset_price_trackers, :reference_date, :datetime
  end
end
