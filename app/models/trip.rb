class Trip < ApplicationRecord
  belongs_to :bus
  has_many :trip_seats, dependent: :destroy
  has_many :holds
  has_many :bookings

  enum :state, { scheduled: 0, canned: 1, done: 2 }

  after_create :copy_seats

  def bump_search_cache
    key = "search:#{origin}:#{destination}:#{depart_at.to_date}:v"
    Rails.cache.write(key, Rails.cache.read(key).to_i + 1)
  end

  private

  def copy_seats
    bus.seats.find_each do |seat|
      trip_seats.create(seat: seat, fare: seat.price, state: :available)
    end
    fares = trip_seats.reload.pluck(:fare)
    update_columns(min_fare: fares.min, max_fare: fares.max, available_seats: trip_seats.size)
  end
end
