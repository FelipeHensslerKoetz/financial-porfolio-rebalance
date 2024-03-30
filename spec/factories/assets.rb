# frozen_string_literal: true

# Asset Factory
FactoryBot.define do
  factory :asset do
    name { Faker::Company.name }
    sector { Faker::Company.industry }
    origin_country { Faker::Address.country }
    image_path { Faker::Avatar.image }
    custom { false }
    identifier { SecureRandom.uuid }
  end

  trait :custom do
    custom { true }
  end
end
