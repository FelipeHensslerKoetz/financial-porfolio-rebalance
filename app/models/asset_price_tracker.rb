class AssetPriceTracker < ApplicationRecord
  belongs_to :asset
  belongs_to :data_origin
  belongs_to :currency

  validates :price, :last_sync_at, presence: true
end
