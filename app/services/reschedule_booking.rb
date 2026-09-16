class RescheduleBooking
  class NotAllowed < StandardError; end

  def self.run(user, old_booking, new_trip, seat_ids)
    raise NotAllowed, "not a live booking" unless old_booking.confirmed?
    raise NotAllowed, "not yours" unless old_booking.user_id == user.id
    raise NotAllowed, "wrong route" unless old_booking.trip.origin == new_trip.origin && old_booking.trip.destination == new_trip.destination
    raise NotAllowed, "wrong operator" unless old_booking.trip.bus.operator_id == new_trip.bus.operator_id
    raise NotAllowed, "same trip" if old_booking.trip_id == new_trip.id
    raise NotAllowed, "inside 1 hour of departure" unless old_booking.can_cancel?

    new_hold = CreateHold.run(user, new_trip, seat_ids)

    booking = nil
    Booking.transaction do
      old_booking.lock!
      raise NotAllowed, "already changed" unless old_booking.confirmed?

      old_seats = old_booking.trip_seats.order(:id).lock
      old_seats.each { |trip_seat| trip_seat.update(state: :available, hold_id: nil, booking_id: nil) }
      old_booking.trip.increment!(:available_seats, old_seats.size)
      old_booking.update(state: :rescheduled)

      new_hold.lock!
      new_seats = new_hold.trip_seats.order(:id).lock
      booking = user.bookings.create(
        trip: new_trip,
        hold: new_hold,
        total: new_seats.sum(&:fare),
        state: :confirmed,
        rescheduled_from: old_booking
      )
      raise NotAllowed, "could not reschedule" unless booking.persisted?

      new_seats.each { |trip_seat| trip_seat.update(state: :booked, booking: booking) }
      new_hold.update(state: :converted)
    end

    old_booking.trip.bump_search_cache
    booking
  end
end
