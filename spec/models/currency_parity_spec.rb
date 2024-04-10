require 'rails_helper'

RSpec.describe CurrencyParity, type: :model do
  describe 'associations' do
    it { should belong_to(:currency_from).class_name('Currency') }
    it { should belong_to(:currency_to).class_name('Currency') }
    it { should belong_to(:data_origin) }
    it { should have_many(:currency_parity_trackers).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:exchange_rate) }
    it { should validate_presence_of(:last_sync_at) }
  end
end
