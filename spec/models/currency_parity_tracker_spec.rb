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
end
