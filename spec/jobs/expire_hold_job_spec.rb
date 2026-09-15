require "rails_helper"

RSpec.describe ExpireHoldJob do
  include ActiveSupport::Testing::TimeHelpers

  it "frees seats after the hold times out" do
    trip = create(:trip)
    trip_seat = trip.trip_seats.first
    hold = CreateHold.run(create(:user), trip, [trip_seat.id])

    travel_to hold.expires_at + 1.second do
      described_class.perform_now(hold.id)
    end

    expect(hold.reload).to be_expired
    expect(trip_seat.reload).to be_available
    expect(trip_seat.hold_id).to be_nil
    expect(trip.reload.available_seats).to eq(4)
  end

  it "does nothing if the hold is still active" do
    trip = create(:trip)
    trip_seat = trip.trip_seats.first
    hold = CreateHold.run(create(:user), trip, [trip_seat.id])

    described_class.perform_now(hold.id)

    expect(hold.reload).to be_active
    expect(trip_seat.reload).to be_held
    expect(trip.reload.available_seats).to eq(3)
  end
end
