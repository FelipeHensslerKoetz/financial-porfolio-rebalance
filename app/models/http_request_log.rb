# Description: Model for http_request_logs table
class HttpRequestLog < ApplicationRecord
  validates :request_url, :request_method, presence: true
end
