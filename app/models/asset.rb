# frozen_string_literal: true

# Asset model
class Asset < ApplicationRecord
  belongs_to :asset_type, class_name: 'AssetType', foreign_key: 'asset_type_id', inverse_of: :assets, optional: false
  belongs_to :user, class_name: 'User', foreign_key: 'user_id', inverse_of: :assets, optional: true

  validates :name, presence: true
end
