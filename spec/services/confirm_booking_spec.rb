require "rails_helper"

RSpec.describe ConfirmBooking do
  it "books the held seats and sums their fares" do
    trip = create(:trip)
    user = create(:user)
    trip_seats = trip.trip_seats.order(:id).first(2)
    hold = CreateHold.run(user, trip, trip_seats.map(&:id))

    booking = ConfirmBooking.run(user, hold)

    expect(booking).to be_confirmed
    expect(booking.total).to eq(trip_seats.sum(&:fare))
    expect(trip_seats.map { |trip_seat| trip_seat.reload.state }.uniq).to eq(["booked"])
    expect(hold.reload).to be_converted
  end

  it "returns the same booking if confirm runs twice" do
    trip = create(:trip)
    user = create(:user)
    hold = CreateHold.run(user, trip, [trip.trip_seats.first.id])

    first = ConfirmBooking.run(user, hold)
    second = ConfirmBooking.run(user, hold)

    expect(second.id).to eq(first.id)
    expect(Booking.count).to eq(1)
  end
end
