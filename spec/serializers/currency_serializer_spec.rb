require 'rails_helper'

RSpec.describe CurrencySerializer do
  let(:currency) { create(:currency) }
  let(:serializer) { described_class.new(currency) }

  it 'returns the expected attributes' do
    expect(serializer.attributes.keys).to contain_exactly(
      :id, :code, :name
    )
  end
end
