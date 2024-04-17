class Rebalance < ApplicationRecord
  include AASM

  belongs_to :rebalance_order

  validates :before_rebalance, :after_rebalance,
            :status, :expires_at, presence: true

  validates :reflected_to_investment_portfolio, inclusion: { in: [true, false] }

  scope :pending, -> { where(status: :pending) }
  scope :processing, -> { where(status: :processing) }
  scope :finished, -> { where(status: :finished) }
  scope :failed, -> { where(status: :failed) }

  aasm column: :status do
    state :pending, initial: true
    state :processing
    state :finished
    state :failed

    event :process do
      transitions from: %i[pending failed], to: :processing
    end

    event :finish do
      transitions from: :processing, to: :finished
    end

    event :fail do
      transitions from: :processing, to: :failed
    end
  end
end
