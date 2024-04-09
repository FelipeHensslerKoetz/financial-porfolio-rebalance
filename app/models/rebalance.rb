class Rebalance < ApplicationRecord
  include AASM

  belongs_to :rebalance_order

  validates :before_rebalance, :after_rebalance,
            :status, :expires_at, presence: true

  validates :reflected_to_investment_portfolio, inclusion: { in: [true, false] }

  aasm column: :status do
    state :pending, initial: true
    state :processing
    state :completed
    state :failed
    state :expired

    event :process do
      transitions from: :pending, to: :processing
    end

    event :complete do
      transitions from: :processing, to: :completed
    end

    event :fail do
      transitions from: :processing, to: :failed
    end

    event :expire do
      transitions from: :pending, to: :expired
    end
  end
end
