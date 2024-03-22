# frozen_string_literal: true

# Base module for AlphaVantage
module AlphaVantage
  class Base
    def get(params: {}, headers: {})
      handle_faraday_errors do
        response = Faraday.get(url, final_params(params),
                               final_headers(headers))

        { 'data' => JSON.parse(response.body) }
      end
    end

    private

    def final_params(params)
      params.merge(base_params)
    end

    def final_headers(headers)
      headers.merge(base_headers)
    end

    def url
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

    def handle_faraday_errors
      yield
    rescue Faraday::Error => e
      error_response(e)
    end

    def error_response(error)
      {
        'error' => {
          'name' => error.class.name,
          'message' => error.message,
          'backtrace' => error.backtrace
        }
      }
    end
  end
end
