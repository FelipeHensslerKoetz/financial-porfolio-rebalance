class AssetPriceTracker < ApplicationRecord
  belongs_to :asset
  belongs_to :data_origin
  belongs_to :currency

  validates :price, :last_sync_at, :reference_date, presence: true
end
