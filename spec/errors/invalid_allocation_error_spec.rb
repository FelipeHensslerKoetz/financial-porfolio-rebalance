require 'rails_helper'

RSpec.describe InvalidAllocationError, type: :error do
  describe '#initialize' do
    it 'returns the error message' do
      investment_portfolio = create(:investment_portfolio)

      error = InvalidAllocationError.new(investment_portfolio:)

      expect(error.message.chomp).to eq("Invalid allocation for investment portfolio with ID: #{investment_portfolio.id}, the current total allocation weight is #{investment_portfolio.total_allocation_weight} and the target allocation is 100.0")
    end
  end

  describe '#investment_portfolio' do
    it 'returns the investment portfolio' do
      investment_portfolio = create(:investment_portfolio)

      error = InvalidAllocationError.new(investment_portfolio:)

      expect(error.investment_portfolio).to eq(investment_portfolio)
    end
  end
end
