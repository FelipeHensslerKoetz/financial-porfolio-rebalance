# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Currency, type: :model do
  describe 'associations' do
    it {
      should have_many(:currency_parities_as_from).class_name('CurrencyParity').with_foreign_key('currency_from_id').dependent(:destroy)
    }
    it {
      should have_many(:currency_parities_as_to).class_name('CurrencyParity').with_foreign_key('currency_to_id').dependent(:destroy)
    }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }

    it 'validates uniqueness of code' do
      create(:currency)
      should validate_uniqueness_of(:code)
    end
  end
end
