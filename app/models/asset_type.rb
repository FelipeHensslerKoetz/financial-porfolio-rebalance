# frozen_string_literal: true

# Description: This file contains the asset type model.
class AssetType < ApplicationRecord
  validates :name, presence: true
end
