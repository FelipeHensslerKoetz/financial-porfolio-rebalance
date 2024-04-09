# frozen_string_literal: true

# Currencies Factory
FactoryBot.define do
  factory :currency do
    name { Faker::Currency.name }
    code { Faker::Currency.code }
  end

  trait :brl do
    name { 'Brazilian Real' }
    code { 'BRL' }
  end

  trait :usd do
    name { 'United States Dollar' }
    code { 'USD' }
  end

  trait :btc do
    name { 'Bitcoin' }
    code { 'BTC' }
  end
end
