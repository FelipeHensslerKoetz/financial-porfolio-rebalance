# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvestmentPortfolio, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:currency) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
