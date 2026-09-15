class ConfirmBooking
  class Expired < StandardError; end

  def self.run(user, hold)
    already = Booking.find_by(hold_id: hold.id)
    return already if already

    booking = nil
    Booking.transaction do
      hold.lock!
      raise Expired, "hold ran out" unless hold.active?
      raise Expired, "hold ran out" if hold.expired_by_time?
      raise Expired, "not yours" unless hold.user_id == user.id

      trip_seats = hold.trip_seats.order(:id).lock.to_a
      still_held = trip_seats.all? { |trip_seat| trip_seat.held? && trip_seat.hold_id == hold.id }
      raise Expired, "hold ran out" unless still_held

      booking = user.bookings.create(
        trip: hold.trip,
        hold: hold,
        total: trip_seats.sum(&:fare),
        state: :confirmed
      )
      raise Expired, "could not book" unless booking.persisted?

      trip_seats.each { |trip_seat| trip_seat.update(state: :booked, booking: booking) }
      hold.update(state: :converted)
    end

    hold.trip.bump_search_cache
    booking
  rescue ActiveRecord::RecordNotUnique
    Booking.find_by(hold_id: hold.id)
  end
end
