require 'rails_helper'

RSpec.describe NoAssetsError, type: :error do
  describe '#initialize' do
    it 'returns the error message' do
      investment_portfolio = create(:investment_portfolio)

      error = NoAssetsError.new(investment_portfolio:)

      expect(error.message).to eq("No assets found for investment portfolio with ID: #{investment_portfolio.id}")
    end
  end

  describe '#investment_portfolio' do
    it 'returns the investment portfolio' do
      investment_portfolio = create(:investment_portfolio)

      error = NoAssetsError.new(investment_portfolio:)

      expect(error.investment_portfolio).to eq(investment_portfolio)
    end
  end
end
