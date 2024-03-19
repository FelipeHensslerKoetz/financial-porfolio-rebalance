class CurrencyParity < ApplicationRecord
  belongs_to :currency_from, class_name: 'Currency', foreign_key: 'currency_from_id'
  belongs_to :currency_to, class_name: 'Currency', foreign_key: 'currency_to_id'
  belongs_to :data_origin

  validates :exchange_rate, :last_sync_at, presence: true
end
