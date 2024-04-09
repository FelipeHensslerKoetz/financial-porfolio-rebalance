require 'rails_helper'

RSpec.describe RebalanceOrder, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:investment_portfolio) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:type) }
    it {
      is_expected.to validate_inclusion_of(:type).in_array(%w[default deposit
                                                              withdraw])
    }
  end

  describe 'aasm' do
    it { is_expected.to have_state(:pending) }
    it {
      is_expected.to transition_from(:pending).to(:processing).on_event(:process)
    }
    it {
      is_expected.to transition_from(:processing).to(:completed).on_event(:complete)
    }
    it {
      is_expected.to transition_from(:processing).to(:failed).on_event(:fail)
    }
  end
end
