require "rails_helper"

RSpec.describe SearchTrips do
  it "returns trips on that corridor and day" do
    on = Date.current + 4
    hit = create(:trip, depart_at: Time.zone.parse("#{on} 21:15"))
    create(:trip, destination: "Goa", depart_at: Time.zone.parse("#{on} 21:15"))
    create(:trip, depart_at: Time.zone.parse("#{on + 1} 21:15"))

    found = SearchTrips.run(from: "Pune", to: "Mumbai", on: on)

    expect(found.map(&:id)).to eq([hit.id])
  end

  it "keeps buses that have the amenity" do
    on = Date.current + 5
    wifi = create(:amenity, name: "wifi")
    bus = create(:bus)
    bus.amenities << wifi
    hit = create(:trip, bus: bus, depart_at: Time.zone.parse("#{on} 22:00"))
    create(:trip, depart_at: Time.zone.parse("#{on} 22:30"))

    found = SearchTrips.run(from: "Pune", to: "Mumbai", on: on, amenity: "wifi")

    expect(found.map(&:id)).to eq([hit.id])
  end
end
