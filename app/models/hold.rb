class Hold < ApplicationRecord
  belongs_to :user
  belongs_to :trip
  has_many :trip_seats
  has_one :booking

  enum :state, { active: 0, expired: 1, converted: 2 }

  before_create :set_token

  def seconds_left
    left = expires_at - Time.current
    left.negative? ? 0 : left.to_i
  end

  def expired_by_time?
    expires_at <= Time.current
  end

  private

  def set_token
    self.token ||= SecureRandom.hex(4)
  end
end
