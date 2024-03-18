# frozen_string_literal: true

# Description: This file contains the asset price model.
class AssetPrice < ApplicationRecord
  belongs_to :data_origin, class_name: 'DataOrigin', foreign_key: 'data_origin_id', inverse_of: :asset_prices, optional: false
  belongs_to :asset, class_name: 'Asset', foreign_key: 'asset_id', inverse_of: :asset_prices, optional: false

  validates :price, :currency, :last_price_sync, :identifier, presence: true
end
