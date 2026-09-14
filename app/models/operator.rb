class Operator < ApplicationRecord
  has_many :buses

  validates :name, presence: true
end
