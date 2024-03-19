FactoryBot.define do
  factory :investment_portfolio_asset do
    asset { nil }
    investment_portfolio { nil }
    allocation_weight { "9.99" }
    quantity { "9.99" }
  end
end
