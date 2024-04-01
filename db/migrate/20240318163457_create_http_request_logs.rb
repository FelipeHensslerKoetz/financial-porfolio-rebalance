class CreateHttpRequestLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :http_request_logs do |t|
      t.string :request_url, null: false
      t.string :request_method, null: false
      t.json :request_headers
      t.json :request_query_params
      t.json :request_body
      t.json :response_body
      t.string :response_status_code
      t.json :response_errors
      t.json :response_headers

      t.timestamps
    end
  end
end
