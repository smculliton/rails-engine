FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Fantasy::Tolkein.poem }
    unit_price { Faker::Commerce.price(range: 0..100.0) }
    merchant_id { nil }
  end
end
