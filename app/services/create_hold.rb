class CreateHold
  class Unavailable < StandardError; end

  def self.run(user, trip, seat_ids)
    ids = Array(seat_ids).map(&:to_i).uniq
    raise Unavailable, "pick a seat" if ids.empty?

    hold = nil
    Hold.transaction do
      trip_seats = trip.trip_seats.where(id: ids).order(:id).lock.to_a
      taken = trip_seats.length != ids.length || trip_seats.any? { |trip_seat| !trip_seat.available? }
      raise Unavailable, "those seats just went" if taken

      hold = user.holds.create(trip: trip, expires_at: 5.minutes.from_now, state: :active)
      raise Unavailable, "could not hold" unless hold.persisted?

      trip_seats.each { |trip_seat| trip_seat.update(state: :held, hold: hold) }
      trip.decrement!(:available_seats, trip_seats.size)
    end

    ExpireHoldJob.set(wait_until: hold.expires_at).perform_later(hold.id)
    trip.bump_search_cache
    hold
  end
end
