FactoryBot.define do
  factory :currency_parity do
    currency_from { nil }
    currency_to { nil }
    exchange_rate { "9.99" }
  end
end
