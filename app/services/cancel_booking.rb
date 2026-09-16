class CancelBooking
  class TooLate < StandardError; end
  FEE = 50

  def self.run(user, booking)
    raise TooLate, "already cancelled" if booking.cancelled?
    raise TooLate, "not a live booking" unless booking.confirmed?
    raise TooLate, "not yours" unless booking.user_id == user.id
    raise TooLate, "inside 1 hour of departure" unless booking.can_cancel?

    Booking.transaction do
      booking.lock!
      raise TooLate, "inside 1 hour of departure" unless booking.can_cancel?

      trip_seats = booking.trip_seats.order(:id).lock
      booking.update(
        state: :cancelled,
        refund: [booking.total - FEE, 0].max,
        cancelled_at: Time.current
      )
      trip_seats.each { |trip_seat| trip_seat.update(state: :available, hold_id: nil, booking_id: nil) }
      booking.trip.increment!(:available_seats, trip_seats.size)
    end

    booking.trip.bump_search_cache
    booking.reload
  end
end
