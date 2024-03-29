require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:assets).class_name('Asset').inverse_of(:user).dependent(:destroy) }
    it { is_expected.to have_many(:investment_portfolios).class_name('InvestmentPortfolio').inverse_of(:user).dependent(:destroy) }
    it { is_expected.to have_many(:rebalance_orders).class_name('RebalanceOrder').inverse_of(:user).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe 'devise' do
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end
end