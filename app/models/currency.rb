# frozen_string_literal: true

# Currency model
class Currency < ApplicationRecord
  has_many :currency_parities_as_from, class_name: 'CurrencyParity',
                                       foreign_key: 'currency_from_id',
                                       inverse_of: :currency_from,
                                       dependent: :restrict_with_error
  has_many :currency_parities_as_to, class_name: 'CurrencyParity',
                                     foreign_key: 'currency_to_id',
                                     inverse_of: :currency_to,
                                     dependent: :restrict_with_error

  validates :name, :code, presence: true
  validates :code, uniqueness: true
end
