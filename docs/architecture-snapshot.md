# Snapshot

Index: [README.md](README.md). Schema: [00-architecture-and-models.md](00-architecture-and-models.md).

```
Operator ──< Bus ──< Seat (catalog price)
              │
              ├── amenities
              └──< Trip ──< TripSeat (fare snapshot, lock row)
                              ├── Hold 5 min (CreateHold)
                              └── Booking (ConfirmBooking, total = sum fare)
```

1. Devise email login  
2. `GET /trips` → `SearchTrips`  
3. `POST /trips/:id/holds` → `CreateHold` (`FOR UPDATE` on trip seats)  
4. `POST /holds/:token/bookings` → `ConfirmBooking` (unique `hold_id`)  
5. Reschedule: `RescheduleBooking` same origin/destination/operator  
6. Cancel: `CancelBooking` (≥1h, total − 50)  
7. Sidekiq: `ExpireHoldJob` → `ExpireHold`  
8. Search cache: `SearchTrips` fetch + `Trip#bump_search_cache`

```
Browser → Route → current_user → Controller → Service
  → TripSeat / Hold / Booking (transaction)
  → job / cache bump → redirect
```
