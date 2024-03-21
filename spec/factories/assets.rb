# frozen_string_literal: true

# Asset Factory
FactoryBot.define do
  factory :asset do
    name { Faker::Company.name }
    asset_type { create(:asset_type) }
    sector { Faker::Company.industry }
    origin_country { Faker::Address.country }
    image_path { Faker::Avatar.image }
    custom { false }
    user { create(:user) }
  end
end
