require 'rails_helper'

RSpec.describe UserSerializer do
  let(:user) { create(:user) }
  let(:serializer) { described_class.new(user) }

  it 'returns the expected attributes' do
    expect(serializer.attributes.keys).to contain_exactly(
      :id, :email, :name
    )
  end
end
