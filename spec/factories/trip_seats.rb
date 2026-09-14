FactoryBot.define do
  factory :trip_seat do
    trip
    seat
    fare { 900 }
    state { :available }
  end
end
