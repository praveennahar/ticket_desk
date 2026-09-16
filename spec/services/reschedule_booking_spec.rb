require "rails_helper"

RSpec.describe RescheduleBooking do
  it "moves a booking onto another trip of the same operator" do
    bus = create(:bus)
    going = create(:trip, bus: bus)
    later = create(:trip, bus: bus, depart_at: going.depart_at + 1.day)
    user = create(:user)
    old_seat = going.trip_seats.first
    hold = CreateHold.run(user, going, [old_seat.id])
    booking = ConfirmBooking.run(user, hold)
    new_seat = later.trip_seats.first

    fresh = RescheduleBooking.run(user, booking, later, [new_seat.id])

    expect(fresh).to be_confirmed
    expect(fresh.rescheduled_from_id).to eq(booking.id)
    expect(booking.reload).to be_rescheduled
    expect(old_seat.reload).to be_available
    expect(new_seat.reload).to be_booked
  end

  it "does not move onto another operator" do
    going = create(:trip)
    other = create(:trip, depart_at: going.depart_at + 1.day)
    user = create(:user)
    hold = CreateHold.run(user, going, [going.trip_seats.first.id])
    booking = ConfirmBooking.run(user, hold)

    expect {
      RescheduleBooking.run(user, booking, other, [other.trip_seats.first.id])
    }.to raise_error(RescheduleBooking::NotAllowed)

    expect(booking.reload).to be_confirmed
  end
end
