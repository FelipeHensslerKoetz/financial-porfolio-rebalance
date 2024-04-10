FactoryBot.define do
  factory :currency_parity_tracker do
    currency_parity { create(:currency_parity) }
    exchange_rate { 5.0 }
    last_sync_at { Time.zone.now }
    data_origin { create(:data_origin) }
    reference_date { Time.zone.now }
  end
end
