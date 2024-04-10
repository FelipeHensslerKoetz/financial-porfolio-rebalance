class CurrencyParityTracker < ApplicationRecord
  belongs_to :currency_parity
  belongs_to :data_origin

  validates :exchange_rate, :reference_date, :last_sync_at, presence: true
end
