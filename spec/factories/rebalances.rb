FactoryBot.define do
  factory :rebalance do
    rebalance_order { create(:rebalance_order) }
    before_rebalance { { 'data' => [] } }
    after_rebalance { { 'data' => [] } }
    status { 'pending' }
    reflected_to_investment_portfolio { false }
    expires_at { Time.zone.tomorrow }
  end
end
