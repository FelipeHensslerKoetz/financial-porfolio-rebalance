# frozen_string_literal: true

# CurrencyParity Factory
FactoryBot.define do
  factory :currency_parity do
    currency_from { build(:currency) }
    currency_to { build(:currency) }
  end
end
