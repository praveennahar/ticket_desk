FactoryBot.define do
  factory :amenity do
    sequence(:name) { |n| "wifi#{n}" }
  end
end
