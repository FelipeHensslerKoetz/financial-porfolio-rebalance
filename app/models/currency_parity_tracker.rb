# TODO: rename to currency_parity_exchange_rates
class CurrencyParityTracker < ApplicationRecord
  include AASM

  belongs_to :currency_parity
  belongs_to :data_origin

  validates :exchange_rate, :reference_date, :last_sync_at, presence: true

  scope :up_to_date, -> { where(status: :up_to_date) }
  scope :outdated, -> { where(status: :outdated) }
  scope :processing, -> { where(status: :processing) }
  scope :error, -> { where(status: :error) }

  aasm column: :status do
    state :up_to_date, initial: true
    state :outdated
    state :processing
    state :error

    event :outdate do
      transitions from: :up_to_date, to: :outdated
    end

    event :process do
      transitions from: :outdated, to: :processing
    end

    event :fail do
      transitions from: :processing, to: :error
    end

    event :success do
      transitions from: :processing, to: :up_to_date
    end

    event :reprocess do
      transitions from: :error, to: :processing
    end
  end
end
