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
    expect(old_seat.booking_id).to be_nil
    expect(new_seat.reload).to be_booked
    expect(new_seat.booking_id).to eq(fresh.id)
  end

  it "frees the old seat and books the new one on the same trip" do
    trip = create(:trip)
    user = create(:user)
    old_seat, new_seat = trip.trip_seats.order(:id).first(2)
    hold = CreateHold.run(user, trip, [old_seat.id])
    booking = ConfirmBooking.run(user, hold)

    fresh = RescheduleBooking.run(user, booking, trip, [new_seat.id])

    expect(fresh).to be_confirmed
    expect(fresh.rescheduled_from_id).to eq(booking.id)
    expect(booking.reload).to be_rescheduled
    expect(old_seat.reload).to be_available
    expect(old_seat.booking_id).to be_nil
    expect(new_seat.reload).to be_booked
    expect(new_seat.booking_id).to eq(fresh.id)
  end

  it "lets another rider hold and book the freed seat" do
    bus = create(:bus)
    going = create(:trip, bus: bus)
    later = create(:trip, bus: bus, depart_at: going.depart_at + 1.day)
    owner = create(:user)
    other = create(:user)
    old_seat = going.trip_seats.first
    hold = CreateHold.run(owner, going, [old_seat.id])
    booking = ConfirmBooking.run(owner, hold)

    expect {
      CreateHold.run(other, going, [old_seat.id])
    }.to raise_error(CreateHold::Unavailable)

    RescheduleBooking.run(owner, booking, later, [later.trip_seats.first.id])

    expect(old_seat.reload).to be_available
    expect(old_seat.hold_id).to be_nil
    expect(old_seat.booking_id).to be_nil

    taken = CreateHold.run(other, going, [old_seat.id])
    expect(old_seat.reload).to be_held
    expect(old_seat.hold_id).to eq(taken.id)

    other_booking = ConfirmBooking.run(other, taken)
    expect(other_booking).to be_confirmed
    expect(old_seat.reload).to be_booked
    expect(old_seat.booking_id).to eq(other_booking.id)
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
