FactoryBot.define do
  factory :bus do
    operator
    sequence(:name) { |n| "Coach #{n}" }
    sequence(:plate) { |n| "KA05AB#{3100 + n}" }
    ac_type { :ac }
    layout_type { :seater }

    after(:create) do |bus|
      next if bus.seats.any?
      bus.seats.create(number: "1A", row: 1, kind: :window, price: 950)
      bus.seats.create(number: "1B", row: 1, kind: :aisle, price: 820)
      bus.seats.create(number: "2A", row: 2, kind: :window, price: 950)
      bus.seats.create(number: "2B", row: 2, kind: :aisle, price: 820)
    end
  end
end
