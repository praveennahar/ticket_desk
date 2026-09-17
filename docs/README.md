# How Ticket desk maps to the assignment

| PDF § | File | App names |
|---|---|---|
| Models / structure | [00-architecture-and-models.md](00-architecture-and-models.md) | `Seat` catalog, `TripSeat` inventory |
| 1. Authentication | [01-authentication-devise.md](01-authentication-devise.md) | Devise `User` |
| 2. Trip search & filter | [02-trip-search-and-filters.md](02-trip-search-and-filters.md) | `SearchTrips` |
| 3. Seat hold (concurrency) | [03-seat-hold.md](03-seat-hold.md) | `CreateHold` → `Hold` |
| 4. Confirm (idempotency) | [04-booking-confirmation.md](04-booking-confirmation.md) | `ConfirmBooking` |
| 5. Reschedule | [05-reschedule.md](05-reschedule.md) | `RescheduleBooking` |
| 6. Cancel + ₹50 fee | [06-cancellation.md](06-cancellation.md) | `CancelBooking` |
| Jobs (hold expiry) | [07-hold-expiry-jobs.md](07-hold-expiry-jobs.md) | `ExpireHoldJob` → `ExpireHold` |
| Cache | [08-search-cache.md](08-search-cache.md) | `Trip#bump_search_cache` |
| One-page map | [09-call-flows.md](09-call-flows.md) | all of the above |
| Where code lives | [10-forms-concerns-helpers.md](10-forms-concerns-helpers.md) | no extra form objects |
| Sketch | [architecture-snapshot.md](architecture-snapshot.md) | picture |

PDF word → our word:

| PDF | Code |
|---|---|
| seat on a trip / lock row | `TripSeat` (`available` / `held` / `booked`) |
| temporary hold | `Hold` (`active` / `expired` / `converted`) |
| confirm booking | `ConfirmBooking` / `Booking` (`confirmed`) |
| reschedule | `RescheduleBooking` |
| cancel | `CancelBooking` |
| ticket price | `bookings.total` = sum of `trip_seats.fare` |
