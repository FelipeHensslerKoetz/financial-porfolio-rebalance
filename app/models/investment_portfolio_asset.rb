# frozen_string_literal: true

# InvestmentPortfolioAsset model
class InvestmentPortfolioAsset < ApplicationRecord
  belongs_to :asset
  belongs_to :investment_portfolio

  validates :allocation_weight, presence: true,
                                numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
