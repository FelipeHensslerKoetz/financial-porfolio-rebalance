# frozen_string_literal: true

# CurrencyParity Factory
FactoryBot.define do
  factory :currency_parity do
    currency_from { build(:currency) }
    currency_to { build(:currency) }
    exchange_rate { 5.10 }
    last_sync_at { Time.now }
    data_origin { build(:data_origin) }
  end
end
