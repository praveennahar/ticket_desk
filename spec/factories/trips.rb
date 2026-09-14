FactoryBot.define do
  factory :trip do
    bus
    origin { "Pune" }
    destination { "Mumbai" }
    depart_at { 3.days.from_now.change(hour: 21, min: 15) }
    arrive_at { depart_at + 4.hours + 30.minutes }
  end
end
