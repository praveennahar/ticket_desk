class ExpireHoldJob < ApplicationJob
  queue_as :default

  def perform(hold_id = nil)
    if hold_id
      ExpireHold.run(Hold.find_by(id: hold_id))
    else
      Hold.active.where("expires_at <= ?", Time.current).find_each { |hold| ExpireHold.run(hold) }
    end
  end
end
