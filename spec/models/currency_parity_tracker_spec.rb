require 'rails_helper'

RSpec.describe CurrencyParityTracker, type: :model do
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
      it 'returns up to date currency parity trackers' do
        up_to_date_currency_parity_tracker = create(:currency_parity_tracker, status: 'up_to_date')
        create(:currency_parity_tracker, status: 'outdated')
        expect(CurrencyParityTracker.up_to_date.count).to eq(1)
        expect(CurrencyParityTracker.up_to_date).to include(up_to_date_currency_parity_tracker)
      end
    end

    describe '.outdated' do
      it 'returns outdated currency parity trackers' do
        outdated_currency_parity_tracker = create(:currency_parity_tracker, status: 'outdated')
        create(:currency_parity_tracker, status: 'up_to_date')
        expect(CurrencyParityTracker.outdated.count).to eq(1)
        expect(CurrencyParityTracker.outdated).to include(outdated_currency_parity_tracker)
      end
    end

    describe '.processing' do
      it 'returns processing currency parity trackers' do
        processing_currency_parity_tracker = create(:currency_parity_tracker, status: 'processing')
        create(:currency_parity_tracker, status: 'up_to_date')
        expect(CurrencyParityTracker.processing.count).to eq(1)
        expect(CurrencyParityTracker.processing).to include(processing_currency_parity_tracker)
      end
    end

    describe '.error' do
      it 'returns error currency parity trackers' do
        error_currency_parity_tracker = create(:currency_parity_tracker, status: 'error')
        create(:currency_parity_tracker, status: 'up_to_date')
        expect(CurrencyParityTracker.error.count).to eq(1)
        expect(CurrencyParityTracker.error).to include(error_currency_parity_tracker)
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
