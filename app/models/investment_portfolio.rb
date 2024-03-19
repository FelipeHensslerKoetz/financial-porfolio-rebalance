# frozen_string_literal: true

# The InvestmentPortfolio model is a representation of the investment_portfolio table in the database.
class InvestmentPortfolio < ApplicationRecord
  belongs_to :user
  belongs_to :currency

  validates :name, presence: true
end
