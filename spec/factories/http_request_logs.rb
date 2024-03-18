FactoryBot.define do
  factory :http_request_log do
    request_url { "MyString" }
    request_method { "MyString" }
    request_headers { {} }
    request_query_params { {} }
    request_body { {} }
    response_body { {} }
    response_status_code { "MyString" }
    response_errors { {}}
    response_headers { {} }
  end
end
