require 'rails_helper'

RSpec.describe AssetPrice do
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
      it 'returns up to date asset prices' do
        up_to_date_asset_price = create(:asset_price, status: 'up_to_date')
        create(:asset_price, status: 'outdated')
        expect(AssetPrice.up_to_date.count).to eq(1)
        expect(AssetPrice.up_to_date).to include(up_to_date_asset_price)
      end
    end

    describe '.outdated' do
      it 'returns outdated asset prices' do
        outdated_asset_price = create(:asset_price, status: 'outdated')
        create(:asset_price, status: 'up_to_date')
        expect(AssetPrice.outdated.count).to eq(1)
        expect(AssetPrice.outdated).to include(outdated_asset_price)
      end
    end

    describe '.processing' do
      it 'returns processing asset prices' do
        processing_asset_price = create(:asset_price, status: 'processing')
        create(:asset_price, status: 'up_to_date')
        expect(AssetPrice.processing.count).to eq(1)
        expect(AssetPrice.processing).to include(processing_asset_price)
      end
    end

    describe '.error' do
      it 'returns error asset prices' do
        error_asset_price = create(:asset_price, status: 'error')
        create(:asset_price, status: 'up_to_date')
        expect(AssetPrice.error.count).to eq(1)
        expect(AssetPrice.error).to include(error_asset_price)
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
