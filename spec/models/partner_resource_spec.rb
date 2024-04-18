require 'rails_helper'

RSpec.describe PartnerResource, type: :model do
  describe 'associations' do
    it { should belong_to(:partner) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }

    describe 'uniqueness' do
      subject { create(:partner_resource, :hg_brasil_stock_price) }
      it { should validate_uniqueness_of(:name) }
    end
  end

  describe 'inclusion' do
    it { should validate_inclusion_of(:name).in_array(PartnerResource::INTEGRATED_RESOURCES_NAMES) }
  end
end
