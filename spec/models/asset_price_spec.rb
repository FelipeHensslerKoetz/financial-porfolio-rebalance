# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssetPrice, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:last_sync_at) }
    it { should validate_presence_of(:identifier) }
  end

  describe 'associations' do
    it { should belong_to(:data_origin).class_name('DataOrigin').with_foreign_key('data_origin_id').inverse_of(:asset_prices).optional(false) }
    it { should belong_to(:asset).class_name('Asset').with_foreign_key('asset_id').inverse_of(:asset_prices).optional(false) }
    it { should belong_to(:currency).class_name('Currency').with_foreign_key('currency_id').inverse_of(:asset_prices).optional(false) }
  end
end
