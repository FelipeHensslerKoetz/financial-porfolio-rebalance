require 'rails_helper'

RSpec.describe CurrencyParityExchangeRate, type: :model do
  describe 'associations' do
    it { should belong_to(:currency_parity) }
    it { should belong_to(:data_origin) }
  end

  describe 'validations' do
    it { should validate_presence_of(:exchange_rate) }
    it { should validate_presence_of(:reference_date) }
    it { should validate_presence_of(:last_sync_at) }
  end

  describe 'scopes' do
    describe '.up_to_date' do
      it 'returns up to date currency parity exchange rate' do
        up_to_date_currency_parity_exchange_rate = create(:currency_parity_exchange_rate, status: 'up_to_date')
        create(:currency_parity_exchange_rate, status: 'outdated')
        expect(CurrencyParityExchangeRate.up_to_date.count).to eq(1)
        expect(CurrencyParityExchangeRate.up_to_date).to include(up_to_date_currency_parity_exchange_rate)
      end
    end

    describe '.outdated' do
      it 'returns outdated currency parity exchange rate' do
        outdated_currency_parity_exchange_rate = create(:currency_parity_exchange_rate, status: 'outdated')
        create(:currency_parity_exchange_rate, status: 'up_to_date')
        expect(CurrencyParityExchangeRate.outdated.count).to eq(1)
        expect(CurrencyParityExchangeRate.outdated).to include(outdated_currency_parity_exchange_rate)
      end
    end

    describe '.processing' do
      it 'returns processing currency parity exchange rate' do
        processing_currency_parity_exchange_rate = create(:currency_parity_exchange_rate, status: 'processing')
        create(:currency_parity_exchange_rate, status: 'up_to_date')
        expect(CurrencyParityExchangeRate.processing.count).to eq(1)
        expect(CurrencyParityExchangeRate.processing).to include(processing_currency_parity_exchange_rate)
      end
    end

    describe '.error' do
      it 'returns error currency parity exchange rate' do
        error_currency_parity_exchange_rate = create(:currency_parity_exchange_rate, status: 'error')
        create(:currency_parity_exchange_rate, status: 'up_to_date')
        expect(CurrencyParityExchangeRate.error.count).to eq(1)
        expect(CurrencyParityExchangeRate.error).to include(error_currency_parity_exchange_rate)
      end
    end
  end

  describe 'aasm' do
    it { should have_state(:up_to_date) }
    it { should transition_from(:up_to_date).to(:outdated).on_event(:outdate) }
    it { should transition_from(:outdated).to(:processing).on_event(:process) }
    it { should transition_from(:processing).to(:error).on_event(:fail) }
    it { should transition_from(:processing).to(:up_to_date).on_event(:success) }
    it { should transition_from(:error).to(:processing).on_event(:reprocess) }
  end
end
