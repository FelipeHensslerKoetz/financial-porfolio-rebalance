class CurrencyParity < ApplicationRecord
  belongs_to :currency_from, class_name: 'Currency', inverse_of: :currency_parities_as_from
  belongs_to :currency_to, class_name: 'Currency', inverse_of: :currency_parities_as_to

  belongs_to :data_origin

  validates :exchange_rate, :last_sync_at, presence: true
end
