# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Asset, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it 'validates uniqueness of identifier' do
      create(:asset)
      should validate_uniqueness_of(:identifier)
    end

    it 'validates uniqueness of name' do
      create(:asset)
      should validate_uniqueness_of(:name)
    end
  end

  describe 'associations' do
    it { should belong_to(:asset_type) }
    it { should belong_to(:user).optional }
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
