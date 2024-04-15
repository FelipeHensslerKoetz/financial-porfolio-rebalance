# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Asset, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:business_name) }
    it { should validate_presence_of(:code) }

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

    describe '.custom' do
      it 'returns custom assets' do
        asset = create(:asset, custom: true)
        create(:asset, custom: false)
        expect(Asset.custom).to eq([asset])
      end
    end

    describe '.by_user' do
      it 'returns assets by user' do
        asset = create(:asset, user:)
        create(:asset, user: nil)
        expect(Asset.by_user(user)).to eq([asset])
      end
    end
  end

  describe 'methods' do
    let(:asset) { create(:asset) }

    describe '#up_to_date?' do
      it 'returns true if there are up to date asset price trackers' do
        create(:asset_price_tracker, asset:, status: 'up_to_date')
        expect(asset.up_to_date?).to eq(true)
      end

      it 'returns false if there are no up to date asset price trackers' do
        create(:asset_price_tracker, asset:, status: 'outdated')
        expect(asset.up_to_date?).to eq(false)
      end
    end
  end
end
