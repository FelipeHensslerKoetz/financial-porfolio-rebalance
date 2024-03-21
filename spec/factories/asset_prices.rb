# frozen_string_literal: true

# AssetPrice Factory
FactoryBot.define do
  factory :asset_price do
    price { Faker::Number.decimal(l_digits: 2) }
    currency { create(:currency) }
    last_sync_at { Time.zone.now }
    identifier { 'asset.code' }
    data_origin { create(:data_origin) }
    asset { create(:asset) }
  end
end
