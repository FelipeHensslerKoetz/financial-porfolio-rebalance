# frozen_string_literal: true

# InvestmentPortfolio Factory
FactoryBot.define do
  factory :investment_portfolio do
    user { build(:user) }
    name { 'My stocks' }
    description { 'Stocks based portfolio' }
    image_path { Faker::Avatar.image }
    currency { build(:currency) }
  end
end
