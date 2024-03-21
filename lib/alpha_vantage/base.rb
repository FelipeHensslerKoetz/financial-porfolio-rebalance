# frozen_string_literal: true

# Base module for AlphaVantage
  module AlphaVantage 
    class Base 
      def get(params: {}, headers: {})
        response = Faraday.get(url, final_params(params), final_headers(headers))

        JSON.parse(response.body)
      end 

      def post(params: {}, headers: {})
        response = Faraday.post(url, params, headers)

        JSON.parse(response.body)
      end 

      def put(params: {}, headers: {})
        response = Faraday.put(url, params, headers)

        JSON.parse(response.body)
      end

      def delete(params:{}, headers: {})
        response = Faraday.delete(url, params, headers)

        JSON.parse(response.body)
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
          "Content-Type": "application/json"
        }
      end

      def base_params
        {
          'apikey' => Rails.application.credentials.alpha_vantage[:secret_key]
        }
      end
    end
  end