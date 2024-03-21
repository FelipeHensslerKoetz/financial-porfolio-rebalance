# frozen_string_literal: true

# InvestmentPortfolioAsset Factory
FactoryBot.define do
  factory :investment_portfolio_asset do
    asset { build(:asset) }
    investment_portfolio { build(:investment_portfolio) }
    allocation_weight { rand(0.0..100.0) }
    quantity { rand(0..100) }
  end
end
