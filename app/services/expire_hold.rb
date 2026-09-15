class ExpireHold
  def self.run(hold)
    return if hold.nil? || !hold.active? || !hold.expired_by_time?

    Hold.transaction do
      hold.lock!
      return unless hold.active?

      trip_seats = hold.trip_seats.order(:id).lock
      trip_seats.each do |trip_seat|
        next unless trip_seat.held? && trip_seat.hold_id == hold.id
        trip_seat.update(state: :available, hold_id: nil)
      end
      hold.update(state: :expired)
      hold.trip.increment!(:available_seats, trip_seats.size)
    end

    hold.trip.bump_search_cache
  end
end
