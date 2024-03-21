# frozen_string_literal: true

# DataOrigin factory
FactoryBot.define do
  factory :data_origin do
    name { Faker::Company.name }
    url { Faker::Internet.url }
  end
end
