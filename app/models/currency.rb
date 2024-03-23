# frozen_string_literal: true

# Currency model
class Currency < ApplicationRecord
  has_many :currency_parity_from, foreign_key: 'currency_from_id', class_name: 'CurrencyParity'
  has_many :currency_parity_to, foreign_key: 'currency_to_id', class_name: 'CurrencyParity'
  has_many :asset_prices, class_name: 'AssetPrice', dependent: :destroy

  validates :name, :code, presence: true
  validates :name, :code, uniqueness: true
end
