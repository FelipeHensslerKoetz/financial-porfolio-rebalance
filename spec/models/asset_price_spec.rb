# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssetPrice, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:currency) }
    it { should validate_presence_of(:last_price_sync) }
    it { should validate_presence_of(:identifier) }
  end

  describe 'associations' do
    it { should belong_to(:data_origin) }
    it { should belong_to(:asset) }
  end
end
