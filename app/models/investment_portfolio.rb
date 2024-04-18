# frozen_string_literal: true

# The InvestmentPortfolio model is a representation of the investment_portfolio table in the database.
class InvestmentPortfolio < ApplicationRecord
  belongs_to :user
  belongs_to :currency
  has_many :investment_portfolio_assets, dependent: :restrict_with_error
  has_many :assets, through: :investment_portfolio_assets

  validates :name, presence: true

  accepts_nested_attributes_for :investment_portfolio_assets, allow_destroy: true

  def total_allocation_weight
    investment_portfolio_assets.sum { |investment_portfolio_asset| investment_portfolio_asset.allocation_weight.to_d }.to_d
  end

  def valid_total_allocation_weight?
    total_allocation_weight == 100.0.to_d
  end
end
