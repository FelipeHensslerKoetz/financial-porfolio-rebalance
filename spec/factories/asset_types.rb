# frozen_string_literal: true

# AssetType Factory
FactoryBot.define do
  factory :asset_type do
    name { %w[ETF Stock Crypto REIT].sample }
  end
end
