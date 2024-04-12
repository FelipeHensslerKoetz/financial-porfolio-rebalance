# frozen_string_literal: true

# The InvestmentPortfolio model is a representation of the investment_portfolio table in the database.
class InvestmentPortfolio < ApplicationRecord
  belongs_to :user
  belongs_to :currency
  has_many :investment_portfolio_assets, dependent: :destroy

  validates :name, presence: true

  accepts_nested_attributes_for :investment_portfolio_assets, allow_destroy: true
end
