# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvestmentPortfolioAsset, type: :model do
  describe 'associations' do
    it { should belong_to(:asset) }
    it { should belong_to(:investment_portfolio) }
  end

  describe 'validations' do
    it { should validate_presence_of(:allocation_weight) }
    it {
      should validate_numericality_of(:allocation_weight).is_greater_than(0).is_less_than_or_equal_to(100)
    }
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
  end
end
