# frozen_string_literal: true

# Asset model
class Asset < ApplicationRecord
  belongs_to :asset_type, class_name: 'AssetType', foreign_key: 'asset_type_id', inverse_of: :assets, optional: false
  belongs_to :user, class_name: 'User', foreign_key: 'user_id', inverse_of: :assets, optional: true
  has_many :asset_prices, class_name: 'AssetPrice', foreign_key: 'asset_id', inverse_of: :asset, dependent: :destroy

  validates :name, presence: true
end
