class RebalanceOrder < ApplicationRecord
  include AASM

  REBALANCE_TYPES = %w[default deposit withdraw].freeze

  belongs_to :user
  belongs_to :investment_portfolio

  validates :status, :type, presence: true
  validates :type, inclusion: { in: REBALANCE_TYPES }

  aasm column: :status do
    state :pending, initial: true
    state :processing
    state :completed
    state :error

    event :process do
      transitions from: :pending, to: :processing
    end

    event :complete do
      transitions from: :processing, to: :completed
    end

    event :fail do
      transitions from: :processing, to: :error
    end

    event :reprocess do
      transitions from: :error, to: :processing
    end
  end
end
