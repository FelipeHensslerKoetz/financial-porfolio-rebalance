# frozen_string_literal: true

# DataOrigin factory
FactoryBot.define do
  factory :data_origin do
    name { Faker::Company.name }
  end

  trait :hg_brasil do
    name { 'HG Brasil' }
  end

  trait :alpha_vantage do
    name { 'Alpha Vantage' }
  end
end
