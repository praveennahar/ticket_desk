class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :trip
  belongs_to :hold
  belongs_to :rescheduled_from, class_name: "Booking", optional: true
  has_many :trip_seats

  enum :state, { confirmed: 0, cancelled: 1, rescheduled: 2 }

  before_create :set_pnr

  def can_cancel?
    confirmed? && trip.depart_at >= 1.hour.from_now
  end

  private

  def set_pnr
    self.pnr ||= "P#{format('%08d', SecureRandom.random_number(100_000_000))}"
  end
end
