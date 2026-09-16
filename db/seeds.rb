admin = User.find_or_initialize_by(email: "admin@ticket.desk")
admin.password = "password" if admin.new_record?
admin.admin = true
admin.save

wifi = Amenity.find_or_create_by(name: "wifi")
charger = Amenity.find_or_create_by(name: "charging")
blanket = Amenity.find_or_create_by(name: "blanket")

surya = Operator.find_or_create_by(name: "Surya Travels") { |o| o.rating = 4.4 }
malabar = Operator.find_or_create_by(name: "Malabar Line") { |o| o.rating = 3.8 }

volvo = surya.buses.find_or_create_by(plate: "MH12CD4491") do |b|
  b.name = "Volvo 9400"
  b.ac_type = :ac
  b.layout_type = :seater
end
volvo.amenities = [wifi, charger] if volvo.amenities.empty?

if volvo.seats.empty?
  [
    ["1A", 1, :window, 980],
    ["1B", 1, :aisle, 860],
    ["2A", 2, :window, 980],
    ["2B", 2, :aisle, 860],
    ["3A", 3, :window, 1100],
    ["3B", 3, :aisle, 860]
  ].each do |number, row, kind, price|
    volvo.seats.create(number: number, row: row, kind: kind, price: price)
  end
end

scania = surya.buses.find_or_create_by(plate: "MH12CD4492") do |b|
  b.name = "Scania Metrolink"
  b.ac_type = :ac
  b.layout_type = :sleeper
end
scania.amenities = [wifi, blanket] if scania.amenities.empty?

if scania.seats.empty?
  [
    ["L1", 1, :lower, 1200],
    ["U1", 1, :upper, 980],
    ["L2", 2, :lower, 1200],
    ["U2", 2, :upper, 980]
  ].each do |number, row, kind, price|
    scania.seats.create(number: number, row: row, kind: kind, price: price)
  end
end

sleeper = malabar.buses.find_or_create_by(plate: "KA01EF2208") do |b|
  b.name = "Bharat Benz"
  b.ac_type = :non_ac
  b.layout_type = :sleeper
end
sleeper.amenities = [blanket] if sleeper.amenities.empty?

if sleeper.seats.empty?
  [
    ["L1", 1, :lower, 750],
    ["U1", 1, :upper, 680],
    ["L2", 2, :lower, 750],
    ["U2", 2, :upper, 680]
  ].each do |number, row, kind, price|
    sleeper.seats.create(number: number, row: row, kind: kind, price: price)
  end
end

nashik = surya.buses.find_or_create_by(plate: "MH12CD4493") do |b|
  b.name = "Volvo B11R"
  b.ac_type = :ac
  b.layout_type = :seater
end
nashik.amenities = [wifi, charger] if nashik.amenities.empty?

if nashik.seats.empty?
  [
    ["1A", 1, :window, 620],
    ["1B", 1, :aisle, 540],
    ["2A", 2, :window, 620],
    ["2B", 2, :aisle, 540]
  ].each do |number, row, kind, price|
    nashik.seats.create(number: number, row: row, kind: kind, price: price)
  end
end

green = Operator.find_or_create_by(name: "Greenline") { |o| o.rating = 4.2 }
multi = green.buses.find_or_create_by(plate: "KA05AB1188") do |b|
  b.name = "Scania Multi-Axle"
  b.ac_type = :ac
  b.layout_type = :seater
end
multi.amenities = [wifi, charger] if multi.amenities.empty?

if multi.seats.empty?
  [
    ["1A", 1, :window, 1450],
    ["1B", 1, :aisle, 1280],
    ["2A", 2, :window, 1450],
    ["2B", 2, :aisle, 1280]
  ].each do |number, row, kind, price|
    multi.seats.create(number: number, row: row, kind: kind, price: price)
  end
end

coast = green.buses.find_or_create_by(plate: "TN01GH7721") do |b|
  b.name = "Bharat Benz 9600"
  b.ac_type = :ac
  b.layout_type = :sleeper
end
coast.amenities = [wifi, blanket] if coast.amenities.empty?

if coast.seats.empty?
  [
    ["L1", 1, :lower, 980],
    ["U1", 1, :upper, 860],
    ["L2", 2, :lower, 980],
    ["U2", 2, :upper, 860]
  ].each do |number, row, kind, price|
    coast.seats.create(number: number, row: row, kind: kind, price: price)
  end
end

konkan = Operator.find_or_create_by(name: "Konkan Express") { |o| o.rating = 3.9 }
goa = konkan.buses.find_or_create_by(plate: "GA07JK3344") do |b|
  b.name = "Volvo 7800"
  b.ac_type = :ac
  b.layout_type = :sleeper
end
goa.amenities = [blanket, charger] if goa.amenities.empty?

if goa.seats.empty?
  [
    ["L1", 1, :lower, 1600],
    ["U1", 1, :upper, 1380],
    ["L2", 2, :lower, 1600],
    ["U2", 2, :upper, 1380]
  ].each do |number, row, kind, price|
    goa.seats.create(number: number, row: row, kind: kind, price: price)
  end
end

# Several times on Pune ↔ Mumbai (Surya) so reschedule has another trip.
# Other corridors so search is not only those two cities.
runs = [
  [volvo, "Pune", "Mumbai", 6, 15, 4],
  [volvo, "Mumbai", "Pune", 11, 0, 4],
  [scania, "Pune", "Mumbai", 14, 0, 5],
  [volvo, "Pune", "Mumbai", 21, 30, 4],
  [sleeper, "Pune", "Mumbai", 23, 0, 5],
  [sleeper, "Mumbai", "Pune", 22, 0, 5],
  [nashik, "Pune", "Nashik", 7, 0, 4],
  [nashik, "Nashik", "Pune", 16, 30, 4],
  [multi, "Bangalore", "Hyderabad", 8, 0, 8],
  [multi, "Hyderabad", "Bangalore", 20, 0, 8],
  [coast, "Bangalore", "Chennai", 22, 0, 6],
  [coast, "Chennai", "Bangalore", 10, 0, 6],
  [goa, "Mumbai", "Goa", 19, 0, 11],
  [goa, "Goa", "Mumbai", 7, 30, 11]
]

added = 0
(0..7).each do |n|
  day = Date.current + n
  runs.each do |bus, from, to, hour, min, hours|
    depart_at = Time.zone.local(day.year, day.month, day.day, hour, min)
    next if depart_at < 2.hours.from_now
    next if Trip.exists?(bus: bus, depart_at: depart_at)

    trip = Trip.create(
      bus: bus,
      origin: from,
      destination: to,
      depart_at: depart_at,
      arrive_at: depart_at + hours.hours,
      state: :scheduled
    )
    added += 1 if trip.persisted?
  end
end

puts "seed: #{Trip.count} trips (#{added} new)."
