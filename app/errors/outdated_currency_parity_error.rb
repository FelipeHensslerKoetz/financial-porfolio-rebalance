class OutdatedCurrencyParityError < StandardError
  attr_reader :currency_parity

  def initialize(currency_parity:)
    @currency_parity = currency_parity
    super("Currency parity with id: #{currency_parity.id} is outdated")
  end
end
