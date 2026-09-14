class Seat < ApplicationRecord
  belongs_to :bus
  has_many :trip_seats

  enum :kind, { window: 0, aisle: 1, lower: 2, upper: 3 }

  validates :number, :price, presence: true
end
