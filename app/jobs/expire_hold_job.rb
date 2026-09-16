class ExpireHoldJob
  include Sidekiq::Job

  def perform(hold_id)
    ExpireHold.run(Hold.find_by(id: hold_id))
  end
end
