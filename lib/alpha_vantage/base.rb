# frozen_string_literal: true

# Base module for AlphaVantage
module AlphaVantage
  class Base < HttpRequest::Base
    private

    def base_url
      Rails.application.credentials.alpha_vantage[:base_url]
    end

    def base_headers
      {
        'Content-Type': 'application/json'
      }
    end

    def base_params
      {
        'apikey' => Rails.application.credentials.alpha_vantage[:secret_key]
      }
    end
  end
end
