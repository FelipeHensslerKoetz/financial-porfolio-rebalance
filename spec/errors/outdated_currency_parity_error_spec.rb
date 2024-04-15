require 'rails_helper'

RSpec.describe OutdatedCurrencyParityError, type: :error do
  describe '#initialize' do
    it 'returns the error message' do
      currency_parity = create(:currency_parity)

      error = OutdatedCurrencyParityError.new(currency_parity:)

      expect(error.message).to eq("Currency parity with id: #{currency_parity.id} is outdated")
    end
  end

  describe '#currency_parity' do
    it 'returns the currency parity' do
      currency_parity = create(:currency_parity)

      error = OutdatedCurrencyParityError.new(currency_parity:)

      expect(error.currency_parity).to eq(currency_parity)
    end
  end
end
