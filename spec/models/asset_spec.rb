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
    it { should have_many(:asset_prices).dependent(:restrict_with_error) }
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

    describe '#updated?' do
      it 'returns true if there are up to date asset prices' do
        create(:asset_price, :with_hg_brasil_stock_price_partner_resource, :updated, asset:)
        expect(asset.updated?).to eq(true)
      end

      it 'returns false if there are no up to date asset prices' do
        create(:asset_price, :with_hg_brasil_stock_price_partner_resource, :outdated, asset:)
        expect(asset.updated?).to eq(false)
      end
    end

    describe '#latest_asset_price' do
      it 'returns the latest asset price' do
        asset_price = create(:asset_price, :with_hg_brasil_stock_price_partner_resource, :updated, asset:, reference_date: Time.zone.today)
        create(:asset_price, :with_hg_brasil_stock_price_partner_resource, :updated, asset:, reference_date: Date.yesterday)
        expect(asset.latest_asset_price).to eq(asset_price)
      end

      it 'returns nil if there are no up to date asset prices' do
        create(:asset_price, :with_hg_brasil_stock_price_partner_resource, :outdated, asset:)
        expect(asset.latest_asset_price).to eq(nil)
      end
    end
  end
end
