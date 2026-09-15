require "rails_helper"

RSpec.describe CreateHold do
  it "holds a free seat for five minutes" do
    trip = create(:trip)
    trip_seat = trip.trip_seats.first
    neha = create(:user)

    hold = CreateHold.run(neha, trip, [trip_seat.id])

    expect(hold).to be_active
    expect(trip_seat.reload).to be_held
    expect(trip_seat.hold_id).to eq(hold.id)
    expect(trip.reload.available_seats).to eq(3)
  end

  it "does not let a second rider hold the same seat" do
    trip = create(:trip)
    trip_seat = trip.trip_seats.first
    CreateHold.run(create(:user), trip, [trip_seat.id])

    expect {
      CreateHold.run(create(:user), trip, [trip_seat.id])
    }.to raise_error(CreateHold::Unavailable)

    expect(Hold.count).to eq(1)
    expect(trip_seat.reload).to be_held
  end
end
