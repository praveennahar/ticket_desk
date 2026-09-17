# 2. Trip search and filters

Public. From, to, date, then rating / price / AC / layout / amenity.

| Piece | Path | For |
|---|---|---|
| Route | `GET /trips` | search |
| Controller | `TripsController#index` | skip login |
| Service | `SearchTrips.run` | SQL + cache |
| Seat map | `GET /trips/:id` | live `trip_seats` (not cached) |

Params: `from`, `to`, `on`, `min_rating`, `min_price`, `max_price`, `ac_type`, `layout_type`, `amenity`.

```
GET /trips?from=Pune&to=Mumbai&on=2026-09-20&amenity=wifi
  TripsController#index
    SearchTrips.run(...)
      Trip.scheduled, origin/destination, that day
      operators.rating, min_fare/max_fare band, bus type, amenity
      Rails.cache.fetch 2 minutes
```

Price filter uses the trip’s seat-price band (`min_fare`–`max_fare`), not a single fare.

Spec: `spec/services/search_trips_spec.rb`

Next: [03-seat-hold.md](03-seat-hold.md)
