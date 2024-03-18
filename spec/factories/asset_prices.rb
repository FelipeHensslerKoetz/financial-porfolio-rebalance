FactoryBot.define do
  factory :asset_price do
    price { "9.99" }
    currency { "MyString" }
    last_price_sync { "2024-03-18 13:06:38" }
    identifier { "MyString" }
    data_origin { nil }
    asset { nil }
  end
end
