FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "rider#{n}@mail.test" }
    password { "password" }

    trait :admin do
      admin { true }
    end
  end
end
