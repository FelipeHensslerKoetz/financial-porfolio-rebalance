require 'rails_helper'

RSpec.describe CurrencyParity, type: :model do
  describe 'associations' do
    it { should belong_to(:currency_from).class_name('Currency') }
    it { should belong_to(:currency_to).class_name('Currency') }
    it { should have_many(:currency_parity_exchange_rates).dependent(:destroy) }
  end

  describe 'methods' do
    describe '#up_to_date?' do
      it 'returns true if there is an up to date currency parity exchange rate' do
        currency_parity = create(:currency_parity)
        create(:currency_parity_exchange_rate, currency_parity:, status: 'up_to_date')
        expect(currency_parity.up_to_date?).to eq(true)
      end

      it 'returns false if there is no up to date currency parity exchange rate' do
        currency_parity = create(:currency_parity)
        create(:currency_parity_exchange_rate, currency_parity:, status: 'outdated')
        expect(currency_parity.up_to_date?).to eq(false)
      end
    end
  end
end
