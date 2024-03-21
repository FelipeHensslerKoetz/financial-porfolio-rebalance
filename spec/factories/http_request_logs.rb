# frozen_string_literal: true

# HttpRequestLog Factory
FactoryBot.define do
  factory :http_request_log do
    request_url { 'http://www.google.com' }
    request_method { 'GET' }
    request_headers { {} }
    request_query_params { {} }
    request_body { {} }
    response_body { {} }
    response_status_code { '200' }
    response_errors { {} }
    response_headers { {} }
  end
end
