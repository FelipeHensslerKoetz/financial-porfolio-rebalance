require 'rails_helper'

RSpec.describe HttpRequestLog, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:request_url) }
    it { should validate_presence_of(:request_method) }
  end
end
