FactoryBot.define do
  factory :asset_price_tracker do
    asset { build(:asset) }
    data_origin { build(:data_origin) }
    code { "code" }
    currency { build(:currency) }
    price { 9.99 }
    last_sync_at { Time.zone.now }
  end
end
