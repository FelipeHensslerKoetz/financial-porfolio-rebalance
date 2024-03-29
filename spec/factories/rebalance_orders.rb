FactoryBot.define do
  factory :rebalance_order do
    user { build(:user) }
    investment_portfolio { build(:investment_portfolio) }
    type { 'default' }
    amount { nil }
    requested_at { Time.zone.now }
  end
end
