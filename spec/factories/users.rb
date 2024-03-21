# frozen_string_literal: true

# User factory
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    encrypted_password { 'password' }
    reset_password_sent_at { nil }
    remember_created_at { nil }
    name { Faker::Name.name }
    jti { 'jti' }
  end
end
