class SearchTrips
  def self.run(from:, to:, on:, min_rating: nil, min_price: nil, max_price: nil, ac_type: nil, layout_type: nil, amenity: nil)
    trips = Trip.scheduled
      .where(origin: from, destination: to)
      .where("depart_at >= ? AND depart_at < ?", on.beginning_of_day, on.end_of_day)
      .joins(bus: :operator)

    trips = trips.where("operators.rating >= ?", min_rating) if min_rating.present?
    trips = trips.where("trips.max_fare >= ?", min_price) if min_price.present?
    trips = trips.where("trips.min_fare <= ?", max_price) if max_price.present?
    trips = trips.where(buses: { ac_type: ac_type }) if ac_type.present?
    trips = trips.where(buses: { layout_type: layout_type }) if layout_type.present?
    if amenity.present?
      trips = trips.joins(bus: :amenities).where(amenities: { name: amenity })
    end

    version = Rails.cache.read("search:#{from}:#{to}:#{on}:v").to_i
    Rails.cache.fetch(["search", from, to, on, min_rating, min_price, max_price, ac_type, layout_type, amenity, version], expires_in: 2.minutes) do
      trips.includes(bus: [:operator, :amenities]).distinct.order(:depart_at, :min_fare).to_a
    end
  end
end
