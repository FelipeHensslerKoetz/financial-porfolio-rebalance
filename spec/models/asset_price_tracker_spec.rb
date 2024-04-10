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

  describe 'aasm' do
    it { is_expected.to have_state(:up_to_date) }
    it { is_expected.to transition_from(:up_to_date).to(:outdated).on_event(:outdate) }
    it { is_expected.to transition_from(:outdated).to(:processing).on_event(:process) }
    it { is_expected.to transition_from(:processing).to(:error).on_event(:fail) }
    it { is_expected.to transition_from(:processing).to(:up_to_date).on_event(:success) }
    it { is_expected.to transition_from(:error).to(:processing).on_event(:reprocess) }
  end
end
