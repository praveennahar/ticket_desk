require "rails_helper"

RSpec.describe CancelBooking do
  it "refunds fare minus the fee and frees the seats" do
    trip = create(:trip)
    user = create(:user)
    trip_seat = trip.trip_seats.first
    hold = CreateHold.run(user, trip, [trip_seat.id])
    booking = ConfirmBooking.run(user, hold)

    CancelBooking.run(user, booking)

    expect(booking.reload).to be_cancelled
    expect(booking.refund).to eq(booking.total - 50)
    expect(trip_seat.reload).to be_available
    expect(trip_seat.booking_id).to be_nil
    expect(trip.reload.available_seats).to eq(4)
  end

  it "does not cancel inside one hour of departure" do
    trip = create(:trip, depart_at: 30.minutes.from_now)
    user = create(:user)
    trip_seat = trip.trip_seats.first
    hold = CreateHold.run(user, trip, [trip_seat.id])
    booking = ConfirmBooking.run(user, hold)

    expect {
      CancelBooking.run(user, booking)
    }.to raise_error(CancelBooking::TooLate)

    expect(booking.reload).to be_confirmed
    expect(trip_seat.reload).to be_booked
  end
end
