require 'rails_helper'

RSpec.describe DataOrigin, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }

    describe 'uniqueness' do
      subject { create(:data_origin) }
      it { should validate_uniqueness_of(:name) }
    end
  end
end
