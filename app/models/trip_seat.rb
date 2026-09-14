class TripSeat < ApplicationRecord
  belongs_to :trip
  belongs_to :seat
  belongs_to :hold, optional: true
  belongs_to :booking, optional: true

  enum :state, { available: 0, held: 1, booked: 2 }
end
