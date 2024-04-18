class Partner < ApplicationRecord
  has_many :partner_resources, dependent: :restrict_with_error

  INTEGRATED_PARTNERS = [
    'HG Brasil',
    'Alpha Vantage'
  ].freeze

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, inclusion: { in: INTEGRATED_PARTNERS }
end
