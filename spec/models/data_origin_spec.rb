require 'rails_helper'

RSpec.describe DataOrigin, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:url) }
  end
end
