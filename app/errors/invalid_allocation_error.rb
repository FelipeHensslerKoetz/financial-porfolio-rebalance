class InvalidAllocationError < StandardError
  attr_reader :investment_portfolio

  def initialize(investment_portfolio:)
    @investment_portfolio = investment_portfolio
    super("Invalid allocation for investment portfolio with ID: #{investment_portfolio.id}, " \
          "the current total allocation weight is #{investment_portfolio.total_allocation_weight} and " \
          'the target allocation is 100.0')
  end
end
