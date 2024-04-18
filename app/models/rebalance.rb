class Rebalance < ApplicationRecord
  include AASM

  belongs_to :rebalance_order

  validates :state_before_rebalance, :state_after_rebalance, :calculation_details, :recommended_actions, :status, presence: true

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
