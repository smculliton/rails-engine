FactoryBot.define do
  factory :merchant do
    name { Faker::Fantasy::Tolkien.unique.character }
  end
end
