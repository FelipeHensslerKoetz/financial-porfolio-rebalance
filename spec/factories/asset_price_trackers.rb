FactoryBot.define do
  factory :asset_price_tracker do
    asset { create(:asset) }
    data_origin { create(:data_origin) }
    code { 'code' }
    currency { create(:currency) }
    price { 9.99 }
    last_sync_at { Time.zone.now }
    reference_date { Time.zone.now }
  end
end
