class PartnerResource < ApplicationRecord
  belongs_to :partner

  INTEGRATED_RESOURCES_NAMES = [
    'HG Brasil - Stock Price',
    'Alpha Vantage - Symbol Search',
    'Alpha Vantage - Global Quote',
    'Alpha Vantage - Currency Exchange Rate'
  ].freeze

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, inclusion: { in: INTEGRATED_RESOURCES_NAMES }
end
