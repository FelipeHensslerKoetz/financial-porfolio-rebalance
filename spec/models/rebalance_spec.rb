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

  describe 'aasm' do
    it { is_expected.to have_state(:pending) }
    it { is_expected.to transition_from(:pending).to(:processing).on_event(:process) }
    it { is_expected.to transition_from(:processing).to(:completed).on_event(:complete) }
    it { is_expected.to transition_from(:processing).to(:failed).on_event(:fail) }
    it { is_expected.to transition_from(:pending).to(:expired).on_event(:expire) }
  end
end
