FactoryBot.define do
  factory :booking do
    user
    trip
    hold
    total { 1770 }
    state { :confirmed }
  end
end
