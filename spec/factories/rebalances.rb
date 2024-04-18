FactoryBot.define do
  factory :rebalance do
    rebalance_order { create(:rebalance_order) }
    state_before_rebalance { { 'data' => [] } }
    state_after_rebalance { { 'data' => [] } }
    calculation_details { { 'data' => [] } }
    recommended_actions { { 'data' => [] } }

    trait :pending do
      status { 'pending' }
    end

    trait :processing do
      status { 'processing' }
    end

    trait :finished do
      status { 'finished' }
    end

    trait :failed do
      status { 'failed' }
    end
  end
end
