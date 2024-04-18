require 'rails_helper'

RSpec.describe Partner, type: :model do
  describe 'associations' do
    it { should have_many(:partner_resources).dependent(:restrict_with_error) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }

    describe 'uniqueness' do
      subject { create(:partner, :hg_brasil) }
      it { should validate_uniqueness_of(:name) }
    end

    describe 'inclusion' do
      it { should validate_inclusion_of(:name).in_array(Partner::INTEGRATED_PARTNERS) }
    end
  end
end
