class MissingCurrencyParityError < StandardError
  attr_reader :currency_from, :currency_to

  def initialize(currency_from:, currency_to:)
    @currency_from = currency_from
    @currency_to = currency_to
    super("Missing currency parity from #{currency_from.code} to #{currency_to.code}")
  end
end
