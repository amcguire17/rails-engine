FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Food.description }
    unit_price { Faker::Number.within(range: 1.0..1000.0) }
    merchant
  end
end
