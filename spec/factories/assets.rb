# frozen_string_literal: true

# Asset Factory
FactoryBot.define do
  factory :asset do
    code { 5.times.map { ('A'..'Z').to_a.sample }.join }
    name { Faker::Company.name }
    business_name { Faker::Company.name }
    kind { %w[stock currency].sample }
    image_path { { url: Faker::Company.logo } }
    custom { false }
  end

  trait :custom do
    custom { true }
  end
end
