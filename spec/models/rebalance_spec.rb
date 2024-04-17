require 'rails_helper'

RSpec.describe Rebalance, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:rebalance_order) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:before_rebalance) }
    it { is_expected.to validate_presence_of(:after_rebalance) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:expires_at) }
  end

  describe 'scopes' do
    describe '.pending' do
      let!(:rebalance) { create(:rebalance, status: :pending) }
      let!(:rebalance_processing) { create(:rebalance, status: :processing) }

      it 'returns rebalances with status pending' do
        expect(described_class.pending).to eq([rebalance])
      end
    end

    describe '.processing' do
      let!(:rebalance) { create(:rebalance, status: :processing) }
      let!(:rebalance_pending) { create(:rebalance, status: :pending) }

      it 'returns rebalances with status processing' do
        expect(described_class.processing).to eq([rebalance])
      end
    end

    describe '.finished' do
      let!(:rebalance) { create(:rebalance, status: :finished) }
      let!(:rebalance_pending) { create(:rebalance, status: :pending) }

      it 'returns rebalances with status finished' do
        expect(described_class.finished).to eq([rebalance])
      end
    end

    describe '.failed' do
      let!(:rebalance) { create(:rebalance, status: :failed) }
      let!(:rebalance_pending) { create(:rebalance, status: :pending) }

      it 'returns rebalances with status failed' do
        expect(described_class.failed).to eq([rebalance])
      end
    end
  end

  describe 'aasm' do
    it { is_expected.to have_state(:pending) }
    it { is_expected.to transition_from(:pending).to(:processing).on_event(:process) }
    it { is_expected.to transition_from(:processing).to(:finished).on_event(:finish) }
    it { is_expected.to transition_from(:processing).to(:failed).on_event(:fail) }
    it { is_expected.to transition_from(:failed).to(:processing).on_event(:process) }
  end
end
