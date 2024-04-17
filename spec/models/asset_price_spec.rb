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
    describe '.updated' do
      it 'returns up to date asset prices' do
        updated_asset_price = create(:asset_price, status: 'updated')
        create(:asset_price, status: 'outdated')
        expect(AssetPrice.updated.count).to eq(1)
        expect(AssetPrice.updated).to include(updated_asset_price)
      end
    end

    describe '.outdated' do
      it 'returns outdated asset prices' do
        outdated_asset_price = create(:asset_price, status: 'outdated')
        create(:asset_price, status: 'updated')
        expect(AssetPrice.outdated.count).to eq(1)
        expect(AssetPrice.outdated).to include(outdated_asset_price)
      end
    end

    describe '.processing' do
      it 'returns processing asset prices' do
        processing_asset_price = create(:asset_price, status: 'processing')
        create(:asset_price, status: 'updated')
        expect(AssetPrice.processing.count).to eq(1)
        expect(AssetPrice.processing).to include(processing_asset_price)
      end
    end

    describe '.failed' do
      it 'returns failed asset prices' do
        failed_asset_price = create(:asset_price, status: 'failed')
        create(:asset_price, status: 'updated')
        expect(AssetPrice.failed.count).to eq(1)
        expect(AssetPrice.failed).to include(failed_asset_price)
      end
    end
  end

  describe 'aasm' do
    it { should have_state(:updated) }
    it { should transition_from(:outdated).to(:scheduled).on_event(:schedule) }
    it { should transition_from(:failed).to(:scheduled).on_event(:schedule) }
    it { should transition_from(:scheduled).to(:processing).on_event(:process) }
    it { should transition_from(:processing).to(:failed).on_event(:fail) }
    it { should transition_from(:processing).to(:updated).on_event(:up_to_date) }
    it { should transition_from(:updated).to(:outdated).on_event(:out_of_date) }
  end
end
