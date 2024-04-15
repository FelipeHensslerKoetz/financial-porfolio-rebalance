class NoAssetsError < StandardError
  attr_reader :investment_portfolio

  def initialize(investment_portfolio:)
    @investment_portfolio = investment_portfolio
    super("No assets found for investment portfolio with ID: #{investment_portfolio.id}")
  end
end
