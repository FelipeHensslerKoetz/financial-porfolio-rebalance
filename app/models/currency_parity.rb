# TODO: create index for currency_from + currency_to (avoid double records)
class CurrencyParity < ApplicationRecord
  belongs_to :currency_from, class_name: 'Currency',
                             inverse_of: :currency_parities_as_from
  belongs_to :currency_to, class_name: 'Currency',
                           inverse_of: :currency_parities_as_to

  has_many :currency_parity_exchange_rates, dependent: :destroy

  def up_to_date?
    currency_parity_exchange_rates.up_to_date.any?
  end
end
