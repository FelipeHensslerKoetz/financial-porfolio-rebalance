# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Asset, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:business_name) }
    it { should validate_presence_of(:code) }
    it { should validate_inclusion_of(:custom).in_array([true, false]) }

    it 'validates uniqueness of code' do
      create(:asset)
      should validate_uniqueness_of(:code)
    end
  end

  describe 'associations' do
    it { should belong_to(:user).optional }
    it { should have_many(:asset_price_trackers).dependent(:destroy) }
  end

  describe 'scopes' do
    let(:user) { create(:user) }

    describe '.global' do
      it 'returns global assets' do
        asset = create(:asset, user: nil, custom: false)
        create(:asset, user:, custom: true)
        expect(Asset.global).to eq([asset])
      end
    end
  end
end
