class Bus < ApplicationRecord
  belongs_to :operator
  has_many :seats, dependent: :destroy
  has_many :bus_amenities, dependent: :destroy
  has_many :amenities, through: :bus_amenities
  has_many :trips

  enum :ac_type, { non_ac: 0, ac: 1 }
  enum :layout_type, { seater: 0, sleeper: 1 }

  validates :plate, presence: true
end
