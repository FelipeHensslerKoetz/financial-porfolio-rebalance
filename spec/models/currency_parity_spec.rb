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

    describe '#latest_currency_parity_exchange_rate' do
      it 'returns the latest currency parity exchange rate' do
        currency_parity = create(:currency_parity)
        currency_parity_exchange_rate = create(:currency_parity_exchange_rate, currency_parity:, reference_date: 1.day.ago)
        create(:currency_parity_exchange_rate, currency_parity:, reference_date: 2.days.ago)
        expect(currency_parity.latest_currency_parity_exchange_rate).to eq(currency_parity_exchange_rate)
      end

      it 'returns nil if there is no up to date currency parity exchange rate' do
        currency_parity = create(:currency_parity)
        create(:currency_parity_exchange_rate, currency_parity:, status: 'outdated')
        expect(currency_parity.latest_currency_parity_exchange_rate).to eq(nil)
      end
    end
  end
end
