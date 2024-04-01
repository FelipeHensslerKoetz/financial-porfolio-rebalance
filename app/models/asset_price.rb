# frozen_string_literal: true

# Description: This file contains the asset price model.
class AssetPrice < ApplicationRecord
  belongs_to :data_origin, optional: false
  belongs_to :asset, optional: false
  belongs_to :currency, optional: false

  validates :price, :last_sync_at, :code, presence: true
end
