# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssetPrice, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:last_sync_at) }
    it { should validate_presence_of(:code) }
  end

  describe 'associations' do
    it { should belong_to(:data_origin).optional(false) }
    it { should belong_to(:asset).optional(false) }
    it { should belong_to(:currency).optional(false) }
  end
end
