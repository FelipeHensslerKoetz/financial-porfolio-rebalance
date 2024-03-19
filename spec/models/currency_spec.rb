# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Currency, type: :model do
  describe 'associations' do
    it { should have_many(:currency_parity_from).with_foreign_key('currency_from_id').class_name('CurrencyParity') }
    it { should have_many(:currency_parity_to).with_foreign_key('currency_to_id').class_name('CurrencyParity') }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
  end
end
