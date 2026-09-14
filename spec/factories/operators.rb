FactoryBot.define do
  factory :operator do
    sequence(:name) { |n| "Kaveri Line #{n}" }
    rating { 4.2 }
  end
end
