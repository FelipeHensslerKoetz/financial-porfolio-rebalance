# frozen_string_literal: true

# Description: This file contains the asset type model.
class AssetType < ApplicationRecord
  validates :name, presence: true

  has_many :assets, class_name: 'Asset', foreign_key: 'asset_type_id', inverse_of: :asset_type, dependent: :destroy
end
