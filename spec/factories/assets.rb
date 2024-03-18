FactoryBot.define do
  factory :asset do
    name { "MyString" }
    asset_type { nil }
    sector { "MyString" }
    origin_country { "MyString" }
    image_path { "MyString" }
    custom { false }
    user { nil }
  end
end
