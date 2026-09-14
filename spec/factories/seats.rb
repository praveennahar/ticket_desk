FactoryBot.define do
  factory :seat do
    bus
    sequence(:number) { |n| "#{n}A" }
    row { 1 }
    kind { :window }
    price { 900 }
  end
end
