# 6. Booking cancellation

Only if ≥ 1 hour before departure. Refund = total − ₹50.

| Piece | Path | For |
|---|---|---|
| Route | `POST /bookings/:pnr/cancel` | keep the PNR |
| Service | `CancelBooking.run(user, booking)` | window + refund + free seats |
| Model | `Booking#can_cancel?` | `confirmed?` and `depart_at >= 1.hour.from_now` |

```
POST /bookings/:pnr/cancel
  CancelBooking
    too late / not confirmed → TooLate (no change)
    state=cancelled, refund=total-50
    trip_seats → available
    available_seats up
```

Spec: `spec/services/cancel_booking_spec.rb`

Next: [07-hold-expiry-jobs.md](07-hold-expiry-jobs.md)
