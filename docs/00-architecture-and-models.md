# Architecture and models

Postgres. Two layers.

```
Catalog (rarely changes)          Inventory (every booking)
Operator ─< Bus ─< Seat           Trip ─< TripSeat  ← lock this row
              │                      │       ├── Hold (5 min)
              └─ amenities           │       └── Booking (PNR)
                                     └─ origin / destination / depart_at
```

`Seat` = 1A on the bus, list `price`.  
`TripSeat` = 1A on **this** trip, frozen `fare`, state `available` / `held` / `booked`.

When a trip is created, `Trip#copy_seats` copies every bus seat into a trip seat (`fare: seat.price`).

```
booking.total  = sum(chosen trip_seats.fare)
refund         = total - 50   (floor 0)
```

## Tables

| Model | Point |
|---|---|
| `User` | Devise email + password |
| `Operator` | `rating` (search filter) |
| `Bus` | `ac_type` ac/non_ac, `layout_type` seater/sleeper |
| `Amenity` / `BusAmenity` | wifi, charging, … |
| `Seat` | `number`, `kind`, `price` |
| `Trip` | `origin`, `destination`, `depart_at`, `min_fare`/`max_fare`, `available_seats` |
| `TripSeat` | unique `(trip_id, seat_id)` — **the mutex** |
| `Hold` | `token`, `expires_at`, state active/expired/converted |
| `Booking` | unique `hold_id`, unique `pnr`, `total`, `refund` |

## Who writes

| Layer | Job |
|---|---|
| Controller | params, `current_user`, redirect |
| Service | transaction, lock, money, state |
| Job | expiry only (`ExpireHoldJob`) |
| Helper | `Rs` text, AC/Sleeper label |

Next: [01-authentication-devise.md](01-authentication-devise.md)
