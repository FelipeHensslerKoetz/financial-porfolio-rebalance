# frozen_string_literal: true

# Asset Factory
FactoryBot.define do
  factory :asset do
    code { 5.times.map { ('A'..'Z').to_a.sample }.join }
    name { Faker::Company.name }
    business_name { Faker::Company.name }
    document { Faker::Company.brazilian_company_number }
    description { Faker::Company.catch_phrase }
    website { Faker::Internet.url }
    kind { %w[stock currency].sample }
    sector { Faker::Company.industry }
    region { Faker::Address.state }
    image_path { { url: Faker::Company.logo } }
    market_time { { open: '09:00', close: '18:00' } }
    custom { false }
  end

  trait :custom do
    custom { true }
  end
end
