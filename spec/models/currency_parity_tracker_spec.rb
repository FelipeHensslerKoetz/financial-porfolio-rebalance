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

  describe 'aasm' do
    it { should have_state(:up_to_date) }
    it { should transition_from(:up_to_date).to(:outdated).on_event(:outdate) }
    it { should transition_from(:outdated).to(:processing).on_event(:process) }
    it { should transition_from(:processing).to(:error).on_event(:fail) }
    it { should transition_from(:processing).to(:up_to_date).on_event(:success) }
    it { should transition_from(:error).to(:processing).on_event(:reprocess) }
  end
end
