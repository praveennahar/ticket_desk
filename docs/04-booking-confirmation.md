# 4. Booking confirmation (idempotency)

Valid hold → booking. Refresh must not create a second PNR.

| Piece | Path | For |
|---|---|---|
| Route | `POST /holds/:hold_token/bookings` | confirm |
| Service | `ConfirmBooking.run(user, hold)` | hold → booking |

```
POST /holds/:token/bookings
  BookingsController#create
    ConfirmBooking.run
      Booking.find_by(hold_id:) already? → return it
      hold.lock!
      must be active, not past expires_at, yours
      INSERT bookings  total = sum(fare)  state=confirmed
      trip_seats → booked, hold → converted
      rescue RecordNotUnique → find the winner
```

Unique index on `bookings.hold_id` is the real guarantee.

Spec: `spec/services/confirm_booking_spec.rb`

Next: [05-reschedule.md](05-reschedule.md)
