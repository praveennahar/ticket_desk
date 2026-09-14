require "rails_helper"

RSpec.describe Trip do
  it "copies each bus seat onto a trip seat and keeps the price" do
    trip = create(:trip)

    expect(trip.trip_seats.count).to eq(4)

    by_number = trip.trip_seats.includes(:seat).each_with_object({}) do |trip_seat, fares|
      fares[trip_seat.seat.number] = trip_seat.fare.to_i
    end

    expect(by_number).to eq("1A" => 950, "1B" => 820, "2A" => 950, "2B" => 820)
    expect(trip.min_fare.to_i).to eq(820)
    expect(trip.max_fare.to_i).to eq(950)
    expect(trip.available_seats).to eq(4)
    expect(trip.trip_seats.map(&:state).uniq).to eq(["available"])
  end

  it "does not reuse trip seats from another trip on the same bus" do
    bus = create(:bus)
    first = create(:trip, bus: bus)
    second = create(:trip, bus: bus, depart_at: first.depart_at + 1.day)

    expect(first.trip_seats.count).to eq(4)
    expect(second.trip_seats.count).to eq(4)
    expect(first.trip_seat_ids & second.trip_seat_ids).to eq([])
  end
end
