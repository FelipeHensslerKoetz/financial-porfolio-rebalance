source "https://rubygems.org"

ruby "3.3.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3", ">= 7.1.3.2"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem "rack-cors"

# Devise is a flexible authentication solution for Rails based on Warden
gem 'devise'

# Devise JWT is a devise extension that uses JWT tokens for user authentication
gem 'devise-jwt'

# JSONAPI::Serializer is a fast JSON:API serializer for Ruby Objects
# gem 'jsonapi-serializer'

# Faker is a library for generating fake data such as names, addresses, and phone numbers
gem 'faker'

# Sidekiq is a simple, efficient background processing for Ruby
gem 'sidekiq', '~> 4.1', '>= 4.1.2'

# Faraday is an HTTP client library that provides a common interface over many adapters
gem 'faraday'

# ActiveModel::Serializer implementation and Rails hooks
gem 'active_model_serializers', '~> 0.10.0'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
  gem "pry"
  gem 'rspec-rails', '~> 6.0.0'
  gem 'shoulda-matchers'
  gem 'factory_bot_rails'
  gem 'webmock'
  gem 'vcr'
  gem 'rubocop'
  gem 'rubocop-rails'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
