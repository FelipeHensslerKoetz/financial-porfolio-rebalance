# frozen_string_literal: true

# Description: This file contains the data origin model.
class DataOrigin < ApplicationRecord
  validates :name, :url, presence: true
  validates :name, uniqueness: true

  has_many :asset_prices, class_name: 'AssetPrice', foreign_key: 'data_origin_id', inverse_of: :data_origin, dependent: :destroy
end
