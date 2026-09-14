FactoryBot.define do
  factory :hold do
    user
    trip
    expires_at { 5.minutes.from_now }
    state { :active }
  end
end
