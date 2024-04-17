class RebalanceOrder < ApplicationRecord
  include AASM

  REBALANCE_TYPES = %w[default deposit withdraw].freeze

  belongs_to :user
  belongs_to :investment_portfolio

  validates :status, :type, presence: true
  validates :type, inclusion: { in: REBALANCE_TYPES }

  scope :scheduled, -> { where(status: :scheduled) }
  scope :processing, -> { where(status: :processing) }
  scope :finished, -> { where(status: :finished) }
  scope :failed, -> { where(status: :failed) }

  aasm column: :status do
    state :scheduled, initial: true
    state :processing
    state :finished
    state :failed

    event :process do
      transitions from: :scheduled, to: :processing
    end

    event :finish do
      transitions from: :processing, to: :finished
    end

    event :fail do
      transitions from: :processing, to: :failed
    end

    event :schedule do
      transitions from: %i[failed], to: :scheduled
    end
  end
end
