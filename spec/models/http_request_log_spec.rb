require 'rails_helper'

RSpec.describe HttpRequestLog, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:request_url) }
    it { should validate_presence_of(:request_method) }
    it { should validate_presence_of(:response_status_code) }
  end
end
