require 'rails_helper'

RSpec.describe MissingCurrencyParityError, type: :error do
  describe '#initialize' do
    it 'returns the error message' do
      currency_from = create(:currency, code: 'USD')
      currency_to = create(:currency, code: 'EUR')

      error = MissingCurrencyParityError.new(currency_from:, currency_to:)

      expect(error.message.chomp).to eq("Missing currency parity from #{currency_from.code} to #{currency_to.code}")
    end
  end

  describe '#currency_from' do
    it 'returns the currency from' do
      currency_from = create(:currency, code: 'USD')
      currency_to = create(:currency, code: 'EUR')

      error = MissingCurrencyParityError.new(currency_from:, currency_to:)

      expect(error.currency_from).to eq(currency_from)
    end
  end

  describe '#currency_to' do
    it 'returns the currency to' do
      currency_from = create(:currency, code: 'USD')
      currency_to = create(:currency, code: 'EUR')

      error = MissingCurrencyParityError.new(currency_from:, currency_to:)

      expect(error.currency_to).to eq(currency_to)
    end
  end
end
