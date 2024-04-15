require 'rails_helper'

RSpec.describe AssetPriceTracker do
  describe 'associations' do
    it { is_expected.to belong_to(:asset) }
    it { is_expected.to belong_to(:data_origin) }
    it { is_expected.to belong_to(:currency) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:last_sync_at) }
    it { is_expected.to validate_presence_of(:reference_date) }
  end

  describe 'scopes' do
    describe '.up_to_date' do
      it 'returns up to date asset price trackers' do
        up_to_date_asset_price_tracker = create(:asset_price_tracker, status: 'up_to_date')
        create(:asset_price_tracker, status: 'outdated')
        expect(AssetPriceTracker.up_to_date.count).to eq(1)
        expect(AssetPriceTracker.up_to_date).to include(up_to_date_asset_price_tracker)
      end
    end

    describe '.outdated' do
      it 'returns outdated asset price trackers' do
        outdated_asset_price_tracker = create(:asset_price_tracker, status: 'outdated')
        create(:asset_price_tracker, status: 'up_to_date')
        expect(AssetPriceTracker.outdated.count).to eq(1)
        expect(AssetPriceTracker.outdated).to include(outdated_asset_price_tracker)
      end
    end

    describe '.processing' do
      it 'returns processing asset price trackers' do
        processing_asset_price_tracker = create(:asset_price_tracker, status: 'processing')
        create(:asset_price_tracker, status: 'up_to_date')
        expect(AssetPriceTracker.processing.count).to eq(1)
        expect(AssetPriceTracker.processing).to include(processing_asset_price_tracker)
      end
    end

    describe '.error' do
      it 'returns error asset price trackers' do
        error_asset_price_tracker = create(:asset_price_tracker, status: 'error')
        create(:asset_price_tracker, status: 'up_to_date')
        expect(AssetPriceTracker.error.count).to eq(1)
        expect(AssetPriceTracker.error).to include(error_asset_price_tracker)
      end
    end
  end

  describe 'aasm' do
    it { is_expected.to have_state(:up_to_date) }
    it { is_expected.to transition_from(:up_to_date).to(:outdated).on_event(:outdate) }
    it { is_expected.to transition_from(:outdated).to(:processing).on_event(:process) }
    it { is_expected.to transition_from(:processing).to(:error).on_event(:fail) }
    it { is_expected.to transition_from(:processing).to(:up_to_date).on_event(:success) }
    it { is_expected.to transition_from(:error).to(:processing).on_event(:reprocess) }
  end
end
